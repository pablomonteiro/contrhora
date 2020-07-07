class Admin::RecordsController < ApplicationController

    before_action :require_authentication

    def index
        search_records
        respond_to do |format|
            format.html
            format.csv { send_data @records.to_csv(nil, nil, nil), filename: "records-#{Date.today}.csv" }
        end
    end

    def search
        search_records
    end

    def import
        file_path = params['file_upload']
        response = Record.import_csv(file_path)
        if response["imported"]
            redirect_to action: :index
        else
            flash[:messages] = response["errors"]
            redirect_to action: :index
        end
    end

    private 

    def search_records
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