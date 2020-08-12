class Admin::RecordsController < ApplicationController

    before_action :require_authentication

    def index
        search_filter = Search.new
        search_filter.define_current_month
        @projects = ['Varejofacil', 'Milênio', 'SysPDV', 'Produto']
        @date_ini_default = search_filter.date_ini
        @date_fin_default = search_filter.date_fin
        find_records search_filter
    end

    def search
        @controller_name = params[:controller]
        search_filter = fill_filter params
        find_records search_filter
    end

    def search_consolidate
        @controller_name = params[:controller]
        search_filter = fill_filter params
        find_consolidate search_filter
    end

    def export
        search_filter = fill_filter params
        find_records search_filter
        respond_to do |format|
            format.csv { send_data Record.to_csv(@records), filename: "records-#{Date.today}.csv" }
        end
    end

    def import
        file_path = params['file_upload']
        importer = RecordsImporter.new
        has_error = importer.import_csv(file_path)
        flash[:messages] = Array.new
        redirect_to action: :index
    end

    def grafics
    end

    def consolidate
        search_filter = Search.new
        search_filter.define_current_month
        @projects = ['Varejofacil', 'Milênio', 'SysPDV', 'Produto']
        @date_ini_default = search_filter.date_ini
        @date_fin_default = search_filter.date_fin
        find_consolidate search_filter
    end

    def line_chart
        result = Record.generate_line_chart
        render json: JSON.parse(result)
    end

    private 

        def fill_filter params
            Search.new(params[:date_ini], params[:date_fin], params[:user], params[:project])
        end

        def find_records search_filter
            record_search = RecordsSearcher.new
            record_search.validate_period search_filter
            @records = record_search.search_records(search_filter)
            @total_spent_time = record_search.calc_total_spent_time @records
        end

        def find_consolidate search_filter
            record_search = RecordsSearcher.new
            record_search.validate_period search_filter
            @records = record_search.search_records_consolidade(search_filter)
            @total_spent_time = record_search.total_spent_time_consolidate @records
        end

end