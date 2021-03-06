class RecordsCreater

    def create newRecord
        unless newRecord.valid?
            puts newRecord.errors[]
            render :new
            return
        end
        newRecord.fill_month_and_year
        newRecord.time_spent = TimeCalculator.calculate_spent_time newRecord
        newRecord.save
        newRecord
    end

    def update id, new_values
        updated_record = Record.new(new_values)
        record = Record.find(id)
        record.fill_month_and_year
        record.time_spent = TimeCalculator.calculate_spent_time updated_record
        record.update(new_values)
        record
    end

    def delete id
        record = Record.find(id)
        record.destroy
    end
end