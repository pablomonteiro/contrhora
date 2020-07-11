class RecordsController < ApplicationController

    before_action :require_authentication

    def index
        @date_ini_default = Date.current.beginning_of_month
        @date_fin_default = Date.current.end_of_month
        search_records(@date_ini_default, @date_fin_default)
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
        search = Search.new
        search.date_ini = params[:date_ini]
        search.date_fin = params[:date_fin]
        unless search.is_valid_period?
            @errors = ['Data Inicial não pode ser maior que Data Final']
            @records = []
            return 
        end
        search_records(search.date_ini, search.date_fin)
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

        def search_records(date_ini, date_fin)
            puts date_ini
            puts date_fin
            @records = Record.search_by_date(Record.of_user(current_user), date_ini, date_fin).register_desc
            @total_spent_time = calc_total_spent_time
        end

end