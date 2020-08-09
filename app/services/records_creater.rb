class RecordsCreater

    def create newRecord
        puts 'creating with creater'
        unless newRecord.valid?
            render :new
            return
        end
        newRecord.fill_month_and_year
        newRecord.time_spent = newRecord.time_spent_in_decimal
        newRecord.save
        newRecord
    end

    def update id, new_values
        puts 'updating with creater'
        record = Record.find(id)
        record.fill_month_and_year
        record.time_spent = record.time_spent_in_decimal
        record.update(new_values)
        record
    end

    def delete id
        record = Record.find(id)
        record.destroy
    end
end