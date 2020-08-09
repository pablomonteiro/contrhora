class RecordsImporter

    def import_csv(file_path)
        records_imported = Array.new
        CSV.foreach(file_path, headers: true, col_sep: ';') do |row|
            line = row.to_h
            user_name = line['Colaborador']
            if user_name.blank? == ''
                next
            end
            user = User.find_user_by_name(user_name)
            if user.present?
                record = csv_record(line)
                record.fill_month_and_year
                record.time_spent = record.time_spent_in_decimal
                record.user = user
                records_imported << record
            end
        end
        save_records(records_imported)
    end

    private 
        def save_records(records)
            error = false
            records.each do |record|
                unless Record.verify_exists?(record)
                    unless record.save
                        error= true
                    end
                end
            end
            error
        end

        def csv_record(line)
            record = Record.new
            record.project = line['Equipe']
            record.issue = line['Tarefa']
            puts 'inicio'
            puts line
            date_in = DateTime.strptime(line['Inicio'], "%m/%d/%Y %H:%M")
            record.register = date_in.to_date
            record.hour_in = date_in.strftime('%H:%M')
            record.hour_out = DateTime.strptime(line['Fim'], "%m/%d/%Y %H:%M").strftime('%H:%M')
            record.requester = line['Solicitado por']
            record.comment = line['O que foi feito']
            record
        end

end