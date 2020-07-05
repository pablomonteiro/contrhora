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

  def self.import_csv(csv)
    imported = true
    errors = Array.new
    csv.each do |row|
      user_name = row['User']
      user = User.find_user_by_name(user_name)
      if user.present?
        record = csv_record(row)
        record.user = user
        record_existent = record_existent(record)
        unless record_existent.present?
          unless record.save
            imported = false
            errors.push(record.errors.messages)
          end
        end
      else
        imported = false
        errors.push('user not found')
      end
    end
    JSON.parse('{"imported":' + imported.to_s + ', "errors": ' + errors.to_json + '}')
  end

  private 

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

    def self.csv_record(csv)
      record = Record.new
      record.project = csv['Project']
      record.issue = csv['Issue']
      record.register = csv['Date']
      record.hour_in = csv['HourIn']
      record.hour_out = csv['HourOut']
      record.requester = csv['Requester']
      record.comment = csv['Comment']
      record
    end

end
