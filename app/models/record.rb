class Record < ApplicationRecord
  belongs_to :user
  validates_presence_of :project, :issue, :comment, :register, :hour_in, :hour_out, :requester, :user_id

  scope :this_month, -> { where("register BETWEEN ? AND ?", Date.current.beginning_of_month, Date.current.end_of_month)}
  scope :user_asc, -> { order('user_id ASC') }
  scope :register_desc, -> { order('register DESC') }

  def self.of_user(user_id)
    where(:user_id => user_id)
  end

  def self.search_by_user(user_id)
    if user_id.present?
      of_user(user_id).register_desc
    else
      this_month.user_asc.register_desc
    end
  end

  def time_spent
    spent = (time_to_minutes(self.hour_out) - time_to_minutes(self.hour_in))
    spent.divmod(60).join(':')
  end

  def self.to_csv(user_id)
    header = %w{User Project IssueDate Hour In Hour Out Requester Comment}
    attributes = %w{user_name project issue register hour_in hour_out requester comment}
    options = {headers: true, col_sep: ';'}
    CSV.generate(options) do |csv|
      csv << header
      self.search_by_user(user_id).each do |record|
        csv << attributes.map{ |attr| record.send(attr) }
      end
    end
  end

  def user_name
    self.user.name
  end

  private 

  def time_to_minutes(time)
    hour, minute = time.split(':').map(&:to_i)
    60 * hour + minute
  end

end
