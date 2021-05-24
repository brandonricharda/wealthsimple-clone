class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:show]
    def show
        @user = User.find(params[:id])
        @accounts = @user.accounts
    end

    def new
        @user = User.new
    end

end