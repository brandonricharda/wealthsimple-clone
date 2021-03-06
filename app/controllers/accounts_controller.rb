class AccountsController < ApplicationController
    before_action :authenticate_user!

    def new
        @account = Account.new
    end

    def create
        @account = Account.new(account_params)
        respond_to do |format|
            if @account.save
                format.html { redirect_to @account }
            else
                format.html { render :new }
            end
        end
    end

    def show
        @account = Account.find(params[:id])
        @transactions = @account.transactions.order("created_at DESC")
        @holding = @account.holding
    end

    private

    def account_params
        params.require(:account).permit(:name, :user_id, :available_balance)
    end

end