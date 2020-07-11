class Admin::RecordsController < ApplicationController

    before_action :require_authentication

    def index
        search_filter = Search.new
        search_filter.define_current_month
        @date_ini_default = search_filter.date_ini
        @date_fin_default = search_filter.date_fin
        @records = Record.search(search_filter)
        @total_spent_time = calc_total_spent_time
    end

    def search
        @controller_name = params[:controller]
        search_filter = Search.new(params[:date_ini], params[:date_fin], params[:user])
        @records = Record.search(search_filter)
        @total_spent_time = calc_total_spent_time
    end

    def export
        search_filter = Search.new(params[:date_ini], params[:date_fin], params[:user])
        @records = Record.search(search_filter)
        respond_to do |format|
            format.csv { send_data Record.to_csv(@records), filename: "records-#{Date.today}.csv" }
        end
    end

    def import
        file_path = params['file_upload']
        has_error = Record.import_csv(file_path)
        # errors = Array.new
        # if has_error 
        #     error << "Alguns registros não puderam ser importados" 
        # end
        flash[:messages] = Array.new
        redirect_to action: :index
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