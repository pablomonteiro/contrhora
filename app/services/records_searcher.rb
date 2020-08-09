class RecordsSearcher

    def search_records(filter)
        records = Record.search_by_user(filter.user_id)
        if filter.project.present?
          records = records.where('project = ?', filter.project)
        end
        Record.search_by_date(records, filter.date_ini, filter.date_fin).user_asc.register_desc
    end

    def validate_period filter
        if filter.is_period_blank?
            return ['Data Inicial e Data Final precisam ser preenchidos!']
        end
        unless filter.is_invalid_period?
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