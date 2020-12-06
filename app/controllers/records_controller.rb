class RecordsController < ApplicationController

    before_action :require_authentication

    def index
        @controller_name = params[:controller]
        search_filter = Search.new
        search_filter.define_current_month
        search_filter.user_id = current_user
        @date_ini_default = search_filter.date_ini
        @date_fin_default = search_filter.date_fin
        search_records(search_filter)
    end

    def new
        @record = Record.new
        @record.register = DateTime.now
    end

    def create
        new_record = Record.new(param_record)
        new_record.user_id = current_user.id
        record_creater = RecordsCreater.new
        @record = record_creater.create new_record
        if @record.errors.any?
            render :new
        else
            redirect_to action: :index, notice: 'Register saved!'
        end
    end

    def edit
        @record = Record.find(params[:id])
    end

    def grafics
    end

    def line_chart
        render json: Record.of_user(current_user).group(:month_year).sum(:time_spent)
    end

    def update
        record_creater = RecordsCreater.new
        @record = record_creater.update params[:id], param_record
        if @record.errors.any?
            render :edit
        else
            redirect_to action: :index, notice: 'Register updated!'
        end
    end

    def destroy
        record_creater = RecordsCreater.new
        record_creater.delete params[:id]
        redirect_to records_path, notice: 'Register deleted!'
    end

    def show
        @record = Record.find(params[:id])
    end

    def search
        @controller_name = params[:controller]
        search_records Search.new(params[:date_ini], params[:date_fin], current_user)
    end

    private 

        def param_record
            params.require(:record).permit(:project_id, :issue, :register, :comment, :hour_in, :hour_out, :requester_id, :user_id)
        end

        def search_records(search_filter)
            record_search = RecordsSearcher.new
            record_search.validate_period search_filter
            @records = record_search.search_records(search_filter)
            @total_spent_time = TimeCalculator.calculate_total_spent_time @records
        end

end