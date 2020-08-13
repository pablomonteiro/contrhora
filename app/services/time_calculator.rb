class TimeCalculator

    def self.consolidate_time_by records
        records.each do |row|
            row[2] = show_time_spent row[2]
        end
        records
    end

    def self.calculate_total_spent_time records
        total = 0
        records.each do |record|
            total += record.time_spent
        end
        show_time_spent total
    end

    def self.total_spent_time_consolidate records
        total = 0
        records.each do |row|
            hours_s, minutes_s = row[2].split(':')
            total += hours_s.to_i * 60 + minutes_s.to_i
        end
        show_time_spent total
    end

    def self.calculate_spent_time record
        hour_out = turned_day record
        hour_out - transform_time_in_minutes(record.hour_in)
    end

    def self.show_time_spent time_in_minutes
        hours, minutes = time_in_minutes.divmod(60)
        mask_time hours.to_i, minutes.to_i
    end

    private 

        def self.transform_time_in_minutes time_string
            hours, minutes = time_string.split(':').map(&:to_i)
            hour_to_minutes(hours) + minutes
        end

        def self.mask_time hour, minutes
            hour.to_s + ':' + minutes.to_s.rjust(2, '0')
        end

        def self.hour_to_minutes time
            (time * 60).to_i
        end

        def self.turned_day record
            a_day_in_minutes = 24 * 60
            hour_out = transform_time_in_minutes(record.hour_out) 
            hour_in = transform_time_in_minutes(record.hour_in) 
            hour_out < hour_in ? hour_out + a_day_in_minutes : hour_out
        end

end