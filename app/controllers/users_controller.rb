class UsersController < ApplicationController
    before_action :require_authentication

    def change_password
        @user = User.find(params[:id])
    end

    def update_password
        @user = User.find(params[:id])
        if @user.update(users_params)
            redirect_to root_path
        else
            puts @user.errors.messages
        end
    end

    def users_params
        params.require(:user).permit(:password, :password_confirmation)
    end
end