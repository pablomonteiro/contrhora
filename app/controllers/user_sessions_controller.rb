class UserSessionsController < ApplicationController
    def create
        @session = UserSession.new(session, params[:user_session])
        if @session.authenticate
            redirect_to root_path, :notice => t('flash.notice.signed_id')
        else
            render :index
        end
    end

    def index
        @session = UserSession.new(session)
    end

    def destroy
        user_session.destroy
		redirect_to root_path 
    end

end