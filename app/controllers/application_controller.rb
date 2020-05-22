class ApplicationController < ActionController::Base

    delegate :current_user, :user_signed_in?, :user_admin?, :to => :user_session
    delegate :all_users, :to => :user
    helper_method :current_user, :user_signed_in?, :user_admin?, :all_users

    def user_session
        UserSession.new(session)
    end

    def user
        User.new
    end

    def require_authentication
        unless user_signed_in?
            redirect_to new_user_session_path,
                :alert => t('flash.alert.needs_login')
        end
    end

    def require_no_authentication
        redirect_to root_path if user_signed_in?
    end

end
