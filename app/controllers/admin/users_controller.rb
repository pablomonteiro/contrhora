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
        define_default_password
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

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        redirect_to admin_users_path, notice: 'User deleted!'
    end

    def show 
        @user = User.find(params[:id])
    end

    def activate
        @user = User.find(params[:id])
        if @user.update(active: true)
            redirect_to action: :index
        else
            puts @user.errors.messages
            render :show
        end
    end

    def deactivate
        @user = User.find(params[:id])
        if @user.update(active: false)
            redirect_to action: :index
        else
            puts @user.errors.messages
            render :show
        end
    end

    private 

    def users_params
        params.require(:user).permit(:name, :login, :email, :password, :password_confirmation, :admin)
    end

    def define_default_password
        default_password = '123'
        @user.password = default_password
        @user.password_confirmation = default_password
    end

end