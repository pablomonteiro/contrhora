class Search
    include ActiveModel::Validations
    attr_accessor :user_id, :date_ini, :date_fin

    validates :date_int, :date_fin, presence: true

    def is_valid_period?
        return date_ini < date_fin
    end

end