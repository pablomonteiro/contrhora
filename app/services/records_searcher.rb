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

    def search_records_consolidade filter
        records = search filter
        consolidate records
    end

    def calc_total_spent_time records
        total = 0
        records.each do |record|
            total += record.time_spent_in_minutes
        end
        total.divmod(60).join(':')
    end

    def total_spent_time_consolidate records
        total = 0
        records.each do |row|
            total += transform_time_in_minutes row[2]
        end
        total.divmod(60).join(':')
    end

    private 

        def search filter
            if filter.project.present?
                Record.joins(:user)
                      .where('project = ? AND register BETWEEN ? AND ?', filter.project, filter.date_ini, filter.date_fin)
                      .group('project', 'users.name')
                      .order('users.name', 'project')
                      .pluck('project', 'users.name', 'SUM(time_spent)')
            else
                Record.joins(:user)
                      .where('register BETWEEN ? AND ?', filter.date_ini, filter.date_fin)
                      .group('project', 'users.name')
                      .order('users.name', 'project')
                      .pluck('project', 'users.name', 'SUM(time_spent)')
            end
        end

        def consolidate records
            records.each do |row|
                row[2] = calculate_time_spent row[2]
            end
            records
        end

        def transform_time_in_minutes time_string
            hour, minute = time_string.split(':').map(&:to_i)
            60 * hour + minute
        end

        def calculate_time_spent time_in_float
            int_value = time_in_float.to_i
            decimal_value = time_in_float.modulo(1)
            minutes = ((decimal_value*60)/100).round(2)
            minutes_in_string = minutes.to_s.gsub('0.', '')
            int_value.to_s + ':' + minutes_in_string.rjust(2, '0')
        end

end