class RecordsSearcher

    def search_records(filter)
        records = Record.search_by_user(filter.user_id)
        if filter.project.present?
          records = records.joins(:project).where('projects.id = ?', filter.project)
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
        TimeCalculator.consolidate_time_by records
    end

    private 

        def search filter
            if filter.project.present?
                Record.joins(:user).joins(:project)
                      .where('projects.id = ? AND register BETWEEN ? AND ?', filter.project, filter.date_ini, filter.date_fin)
                      .group('projects.name', 'users.name')
                      .order('users.name', 'projects.name')
                      .pluck('projects.name', 'users.name', 'SUM(time_spent)')
            else
                Record.joins(:user).joins(:project)
                      .where('register BETWEEN ? AND ?', filter.date_ini, filter.date_fin)
                      .group('projects.name', 'users.name')
                      .order('users.name', 'projects.name')
                      .pluck('projects.name', 'users.name', 'SUM(time_spent)')
            end
        end
end