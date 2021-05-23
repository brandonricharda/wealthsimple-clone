class UsersController < ApplicationController

    def show
        @user = User.find(params[:id])
        @accounts = @user.accounts
    end

    def new
        @user = User.new
    end


end