class RecordsSearcher

    def teste 
        puts 'hflaksjdfhla serviuce eeee'   
    end

    def search_records(search_filter)
      Record.search_by_date(Record.of_user(search_filter.user_id), search_filter.date_ini, search_filter.date_fin).register_desc
    end

    def validate_period search_filter
        if search_filter.is_period_blank?
            return ['Data Inicial e Data Final precisam ser preenchidos!']
        end
        unless search_filter.is_invalid_period?
            return ['Data Inicial não pode ser maior que Data Final']
        end
    end

    def calc_total_spent_time records
        total = 0
        records.each do |record|
            total += record.time_spent_in_minutes
        end
        total.divmod(60).join(':')
    end

end