class AccountsController < ApplicationController

    def new
        @account = Account.new
    end

    def create
        @account = Account.new(account_params)
        respond_to do |format|
            if @account.save
                format.html { redirect_to @account }
            else
                format.html { redirect_to request.referrer }
            end
        end
    end

    def show
        @account = Account.find(params[:id])
    end

    private

    def account_params
        params.require(:account).permit(:name, :user_id, :available_balance)
    end

end