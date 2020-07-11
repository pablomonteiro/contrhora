class RecordsController < ApplicationController

    before_action :require_authentication

    def index
        @controller_name = params[:controller]
        search_filter = Search.new
        search_filter.define_current_month
        @date_ini_default = search_filter.date_ini
        @date_fin_default = search_filter.date_fin
        search_records(search_filter)
    end

    def new
        @record = Record.new
    end

    def create
        @record = Record.new(param_record)
        @record.user_id = current_user.id
        if @record.save
            redirect_to action: :index, notice: 'Register saved!'
        else
            puts @record.errors.messages
            render :new
        end
    end

    def edit
        @record = Record.find(params[:id])
    end

    def update
        @record = Record.find(params[:id])
        if @record.update(param_record)
            redirect_to action: :index, notice: 'Register updated!'
        else
            puts @record.errors.messages
            render :edit
        end
    end

    def destroy
        @record = Record.find(params[:id])
        @record.destroy
        redirect_to records_path, notice: 'Register deleted!'
    end

    def show
        @record = Record.find(params[:id])
    end

    def search
        @controller_name = params[:controller]
        search_filter = Search.new(params[:date_ini], params[:date_fin])
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
        search_records(search_filter)
    end

    private 

    def param_record
        params.require(:record).permit(:project, :issue, :register, :comment, :hour_in, :hour_out, :requester, :user_id)
    end

    private 

        def calc_total_spent_time
            total = 0
            @records.each do |record|
                total += record.time_spent_number
            end
            total.divmod(60).join(':')
        end

        def search_records(search_filter)
            @records = Record.search_by_date(Record.of_user(current_user), search_filter.date_ini, search_filter.date_fin).register_desc
            @total_spent_time = calc_total_spent_time
        end

end