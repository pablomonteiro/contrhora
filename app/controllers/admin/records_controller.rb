class Admin::RecordsController < ApplicationController

    before_action :require_authentication

    def index
        @controller_name = params[:controller]
        user_search = params[:user_id]    
        date_ini = params[:date_ini]
        date_fin = params[:date_fin]
        @records = Record.search(user_search, date_ini, date_fin)
        @total_spent_time = calc_total_spent_time
        respond_to do |format|
            format.html
            format.csv { send_data @records.to_csv(user_search), filename: "records-#{Date.today}.csv" }
        end
    end

    private 

    def calc_total_spent_time
        total = 0
        @records.each do |record|
            total += record.time_spent_number
        end
        total.divmod(60).join(':')
    end

end