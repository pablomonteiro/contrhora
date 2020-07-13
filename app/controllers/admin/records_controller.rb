class Admin::RecordsController < ApplicationController

    before_action :require_authentication

    def index
        search_filter = Search.new
        search_filter.define_current_month
        @date_ini_default = search_filter.date_ini
        @date_fin_default = search_filter.date_fin
        find_records search_filter
    end

    def search
        @controller_name = params[:controller]
        search_filter = Search.new(params[:date_ini], params[:date_fin], params[:user])
        find_records search_filter
    end

    def export
        search_filter = Search.new(params[:date_ini], params[:date_fin], params[:user])
        find_records search_filter
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

    def grafics
    end

    def line_chart
        records_by_user = Record.joins(:user).group('users.name', :month_year).sum(:time_spent)
        list = records_by_user.group_by {|k| k[0][0]}.map {|k,v| {name: k, data: v.map{|k, v| {k[1] => v}}}}
        list.each do |row|
            json = []
            row[:data].each do |d|
                json << d.keys.first.to_json + ':' + d.values.first.to_s 
            end
            row[:data] = '{' + json.join(',') + '}'
            row[:data] = row[:data]
        end 
        result = list.to_json.gsub('"{', "{").gsub('"}', "}").gsub('\\', "")
        render json: JSON.parse(result)
    end

    private 

        def find_records search_filter
            if search_filter.is_period_blank?
                @errors = ['Data Inicial e Data Final precisam ser preenchidos!']
                @records = []
                return 
            end
            unless search_filter.is_invalid_period?
                @errors = ['Data Inicial não pode ser maior que Data Final']
                @records = []
                return 
            end
            @records = Record.search(search_filter)
            @total_spent_time = calc_total_spent_time
        end

        def calc_total_spent_time
            total = 0
            @records.each do |record|
                total += record.time_spent_in_minutes
            end
            total.divmod(60).join(':')
        end

end