class ApplicationController < ActionController::Base

    delegate :current_user, :user_signed_in?, :user_admin?, :to => :user_session
    delegate :all_users, :to => :user
    helper_method :current_user, :user_signed_in?, :user_admin?, :all_users
    before_action :set_locale
    layout :default_layout

    def user_session
        UserSession.new(session)
    end

    def user
        User.new
    end

    def require_authentication
        unless user_signed_in?
            redirect_to user_sessions_path,
                :alert => t('flash.alert.needs_login')
        end
    end

    def require_no_authentication
        redirect_to root_path if user_signed_in?
    end

    private 

    def set_locale
        I18n.locale = extract_locale || I18n.default_locale
    end

    def extract_locale
        parsed_locale = params[:locale]
        I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
        
    end

    def default_url_option
        { locale: I18n.locale }
    end

    def default_layout
        is_a?(UserSessionsController) ? false : "application"
    end
end
