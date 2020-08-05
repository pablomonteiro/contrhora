class Search
    include ActiveModel::Validations
    attr_accessor :user_id, :date_ini, :date_fin, :project

    validates :date_ini, :date_fin, presence: true
    
    def initialize(date_ini = nil, date_fin = nil, user_id = nil, project = nil)
        @user_id = user_id 
        @date_ini = date_ini
        @date_fin = date_fin
        @project = project
    end

    def define_current_month
        @date_ini = Date.current.beginning_of_month
        @date_fin = Date.current.end_of_month
    end

    def is_period_blank?
        date_ini.blank? || date_fin.blank?
    end

    def is_invalid_period?
        date_ini < date_fin
    end

end