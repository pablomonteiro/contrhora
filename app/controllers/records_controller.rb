class RecordsController < ApplicationController

    before_action :require_authentication

    def index
        @controller_name = params[:controller]
        @records = Record.of_user(current_user).this_month.register_desc
        @total_spent_time = calc_total_spent_time
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
            render :index
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

end