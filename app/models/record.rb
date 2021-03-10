require 'csv'
require 'json'

class Record < ApplicationRecord
  belongs_to :user
  belongs_to :requester
  belongs_to :project
  validates_presence_of :project_id, :issue, :comment, :register, :hour_in, :hour_out, :requester_id, :user_id

  scope :user_asc, -> { order('user_id ASC') }
  scope :register_desc, -> { order('register DESC') }
  scope :record_existent, ->(record) {where("project = ? AND issue = ? AND register = ? AND hour_in = ? AND hour_out = ?", record.project, record.issue, record.register, record.hour_in, record.hour_out)}

  def self.of_user(user_id)
    where(:user_id => user_id)
  end

  def self.to_csv(records)
    header = %w{Usuario Projeto Issue Data Entrada Saida TempoGasto Solicitante Observacao}
    attributes = %w{user_name project_name issue register hour_in hour_out time_spent_to_s requester_name comment}
    options = {headers: true, col_sep: ';'}
    CSV.generate(options) do |csv|
      csv << header
      records.each do |record|
        csv << attributes.map{ |attr| record.send(attr) }
      end
    end
  end

  def user_name
    self.user.name
  end

  def project_name
    self.project.name
  end

  def requester_name
    self.requester.name
  end 

  def self.verify_exists? record
    record_existent(record).present?
  end

  def fill_month_and_year
    self.month_year = self.register.strftime("%m/%Y")
    self.month = self.register.strftime("%m").to_i
    self.year = self.register.strftime("%Y").to_i
  end

  def self.search_by_date(records, date_in, date_fin)
    if date_in.present? && date_fin.present?
      records.where("register BETWEEN ? AND ?", date_in, date_fin)
    else
      records
    end
  end

  def self.generate_line_chart
    records_by_user = Record.joins(:user).group('users.name', :month_year).sum(:time_spent)
    list = records_by_user.group_by {|k| k[0][0]}.map {|k,v| {name: k, data: v.map{|k, v| {k[1] => v}}}}
    list.each do |row|
        json = []
        row[:data].each do |d|
            json << d.keys.first.to_json + ':' + d.values.first.to_s 
        end
        row[:data] = '{' + json.join(',') + '}'
        row[:data] = row[:data]
    end 
    list.to_json.gsub('"{', "{").gsub('"}', "}").gsub('\\', "")
  end

  def time_spent_to_s
    TimeCalculator.show_time_spent self.time_spent
  end

  private 

    def self.search_by_user(user_id)
      if user_id.present?
        records = of_user(user_id)
      else
        Record.all
      end
    end

end
