require 'rails_helper'

RSpec.describe Transaction, :type => :model do

    describe "#create" do

        let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"]) }

        let(:account) { user.accounts.create(:name => ENV["account_name"], :available_balance => 1000, :asset_balance => 1000) }

        context "when called with no params" do

            let(:transaction) { Transaction.create }

            it "doesn't create record" do
                expect { transaction }.to_not change { Transaction.count }
            end

            it "returns three errors" do
                expect(transaction.errors.count).to eql 4
            end

            it "returns amount blank error" do
                expect(transaction.errors[:amount].first).to eql "can't be blank"
            end

            it "returns description blank error" do
                expect(transaction.errors[:description].first).to eql "can't be blank"
            end

            it "returns account blank error" do
                expect(transaction.errors[:account].first).to eql "must exist"
            end

            it "returns description not accepted error" do
                expect(transaction.errors[:description].last).to eql "is not included in the list"
            end

        end

        context "when called with required params" do

            let(:transaction) { account.transactions.create(:amount => 1000, :description => "Investment") }

            it "creates record" do
                expect { transaction }.to change { Transaction.count }
            end
            
            it "returns zero errors" do
                expect(transaction.errors.count).to eql 0
            end

        end

        context "when called with description" do

            it "accepts Investment" do
                expect { account.transactions.create(:amount => 1000, :description => "Investment") }.to change { Account.count }.by 1
            end

            it "accepts Deposit" do
                expect { account.transactions.create(:amount => 1000, :description => "Deposit") }.to change { Account.count }.by 1
            end

            it "accepts Withdrawal" do
                expect { account.transactions.create(:amount => 1000, :description => "Withdrawal") }.to change { Account.count }.by 1
            end

            it "rejects anything else" do
                expect { account.transactions.create(:amount => 1000, :description => "anything else") }.to_not change { Transaction.count }
            end

        end

    end

end
