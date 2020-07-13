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
        @record.register = DateTime.now
    end

    def create
        @record = Record.new(param_record)
        @record.user_id = current_user.id
        unless @record.valid?
            render :new
            return
        end
        @record.month_year = @record.register.strftime("%m/%Y")
        @record.time_spent = @record.time_spent_in_decimal
        if @record.save
            redirect_to action: :index, notice: 'Register saved!'
        else
            render :new
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
        @record = Record.find(params[:id])
        @record.month = @record.register.strftime("%m").to_i
        @record.year = @record.register.strftime("%Y").to_i
        @record.month_year = @record.register.strftime("%m/%Y")
        @record.time_spent = @record.time_spent_in_decimal
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
                total += record.time_spent_in_minutes
            end
            total.divmod(60).join(':')
        end

        def search_records(search_filter)
            @records = Record.search_by_date(Record.of_user(current_user), search_filter.date_ini, search_filter.date_fin).register_desc
            @total_spent_time = calc_total_spent_time
        end

end