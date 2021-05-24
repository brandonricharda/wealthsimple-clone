class TransactionsController < ApplicationController

    def new
        @transaction = Transaction.new
    end

    def create
        @transaction = Transaction.new(transaction_params)
        respond_to do |format|
            if @transaction.save
                format.html { redirect_to @transaction.account }
            else
                format.html { render :new }
            end
        end
    end

    private

    def transaction_params
        params.require(:transaction).permit(:amount, :description, :account_id)
    end

end