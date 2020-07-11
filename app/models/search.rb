class Search
    include ActiveModel::Validations
    attr_accessor :user_id, :date_ini, :date_fin

    validates :date_ini, :date_fin, presence: true
    
    def initialize(date_ini = nil, date_fin = nil, user_id = nil)
        @user_id = user_id 
        @date_ini = date_ini
        @date_fin = date_fin
    end

    def define_current_month
        @date_ini = Date.current.beginning_of_month
        @date_fin = Date.current.end_of_month
    end

    def is_valid_period?
        return date_ini < date_fin
    end

end