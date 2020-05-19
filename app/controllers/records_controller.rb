class RecordsController < ApplicationController

    before_action :require_authentication

    def new
        @record = Record.new
    end

    def create
        @record = Record.new(param_record)
        if @record.save
            redirect_to @record, :notice => 'Register saved!'
        else
            render :new
        end
    end

    def show
        @record = Record.find(params[:id])
    end

    private 

    def param_record
        params.require(:record).permit(:project, :issue, :register, :comment, :hour_in, :hour_out, :requester, :user_id)
    end

end