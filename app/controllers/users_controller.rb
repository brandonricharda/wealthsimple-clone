class UsersController < ApplicationController

    def show
        @user = User.find(params[:id])
        @accounts = @user.accounts
    end

end