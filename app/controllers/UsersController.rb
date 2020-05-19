class UsersController < ApplicationController

    before_action :require_authentication

    def new
        @user = User.new
    end

    def create
        @user = User.new(users_params)
        puts 'passou create'
        if @user.save
            puts 'passou save'
            redirect_to @user, :notice => 'User saved!'
        else
            puts 'passou new'
            puts @user.errors.messages
            render :new
        end
    end

    private 

    def users_params
        params.require(:user).permit(:name, :login, :email, :password, :password_confirmation, :admin)
    end

end