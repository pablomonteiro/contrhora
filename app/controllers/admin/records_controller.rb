class Admin::RecordsController < ApplicationController

    before_action :require_authentication

    def index
        seach_records
        respond_to do |format|
            format.html
            format.csv { send_data @records.to_csv(user_id, date_ini, date_fin), filename: "records-#{Date.today}.csv" }
        end
    end

    def search
        seach_records
    end

    private 

    def seach_records
        @controller_name = params[:controller]
        user_id = params[:user]    
        date_ini = params[:date_ini]
        date_fin = params[:date_fin]
        @records = Record.search(user_id, date_ini, date_fin)
        @total_spent_time = calc_total_spent_time
    end

    def calc_total_spent_time
        total = 0
        @records.each do |record|
            total += record.time_spent_number
        end
        total.divmod(60).join(':')
    end

end