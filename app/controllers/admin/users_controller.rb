class Admin::UsersController < ApplicationController

    before_action :require_authentication

    def index
        @users = User.all
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(users_params)
        if @user.save
            redirect_to action: :new, :notice => 'User saved!'
        else
            puts @user.errors.messages
            render :new
        end
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        if @user.update(users_params)
            redirect_to action: :index
        else
            puts @user.errors.messages
            render :show
        end
    end

    def show 
        @user = User.find(params[:id])
    end

    private 

    def users_params
        params.require(:user).permit(:name, :login, :email, :password, :password_confirmation, :admin)
    end

end