require 'csv'
require 'json'

class Record < ApplicationRecord
  belongs_to :user
  validates_presence_of :project, :issue, :comment, :register, :hour_in, :hour_out, :requester, :user_id

  scope :this_month, -> { where("register BETWEEN ? AND ?", Date.current.beginning_of_month, Date.current.end_of_month)}
  scope :user_asc, -> { order('user_id ASC') }
  scope :register_desc, -> { order('register DESC') }
  scope :record_existent, ->(record) {where("project = ? AND issue = ? AND register = ? AND hour_in = ? AND hour_out = ?", record.project, record.issue, record.register, record.hour_in, record.hour_out)}

  def self.of_user(user_id)
    where(:user_id => user_id)
  end

  def self.search(user_search, date_ini, date_fin)
    if user_search.present? || (date_ini.present? && date_fin.present?)
      records = search_by_user(user_search)
      search_by_date(records, date_ini, date_fin)
    else
      this_month.user_asc.register_desc
    end
  end

  def time_spent
    spent = (time_to_minutes(self.hour_out) - time_to_minutes(self.hour_in))
    spent.divmod(60).join(':')
  end

  def time_spent_number
    time_to_minutes(time_spent)
  end

  def self.to_csv(user_id, date_ini, date_fin)
    header = %w{User Project Issue Date HourIn HourOut Requester Comment}
    attributes = %w{user_name project issue register hour_in hour_out requester comment}
    options = {headers: true, col_sep: ';'}
    CSV.generate(options) do |csv|
      csv << header
      self.search(user_id, date_ini, date_fin).each do |record|
        csv << attributes.map{ |attr| record.send(attr) }
      end
    end
  end

  def user_name
    self.user.name
  end

  def self.import_csv(file_path)
    records_imported = Array.new
    
    CSV.foreach(file_path, headers: true, col_sep: ';') do |row|
      line = row.to_h
      user_name = line['Colaborador']
      if user_name.blank? == ''
        next
      end
      user = User.find_user_by_name(user_name)
      if user.present?
        record = csv_record(line)
        record.user = user
        records_imported << record
      else
        puts 'User ' + user_name.to_s + ' not found!'
      end
    end
    save_records(records_imported)
  end

  private 

    def self.save_records(records)
      error = false
      records.each do |record|
        unless record_existent(record).present?
          unless record.save
            puts record.errors.messages
            error= true
          end
        end
      end
      error
    end

    def time_to_minutes(time)
      hour, minute = time.split(':').map(&:to_i)
      60 * hour + minute
    end

    def self.search_by_user(user_id)
      if user_id.present?
        records = of_user(user_id)
      else
        Record.all
      end
    end

    def self.search_by_date(records, date_in, date_fin)
      if date_in.present? && date_fin.present?
        records.where("register BETWEEN ? AND ?", date_in, date_fin)
      else
        records
      end
    end

    def self.csv_record(line)
      record = Record.new
      record.project = line['Equipe']
      record.issue = line['Tarefa']
      date_in = DateTime.strptime(line['Inicio'], "%m/%d/%Y %H:%M")
      record.register = date_in.to_date
      record.hour_in = date_in.strftime('%H:%M')
      record.hour_out = DateTime.strptime(line['Fim'], "%m/%d/%Y %H:%M").strftime('%H:%M')
      record.requester = line['Solicitado por']
      record.comment = line['O que foi feito']
      record
    end

end
