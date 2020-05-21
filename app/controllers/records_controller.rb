class RecordsController < ApplicationController

    before_action :require_authentication

    def index
        @records = Record.of_user(current_user).this_month.register_desc
    end

    def new
        @record = Record.new
    end

    def create
        @record = Record.new(param_record)
        @record.user_id = current_user.id
        if @record.save
            redirect_to action: :index, :notice => 'Register saved!'
        else
            puts @record.errors.messages
            render :new
        end
    end

    def destroy
        @record = Record.find(params[:id])
        @record.destroy
        redirect_to records_path, :notice => 'Register deleted!'
    end

    def show
        @record = Record.find(params[:id])
    end

    private 

    def param_record
        params.require(:record).permit(:project, :issue, :register, :comment, :hour_in, :hour_out, :requester, :user_id)
    end

end