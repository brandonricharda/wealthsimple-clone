require 'rails_helper'

RSpec.describe Transaction, :type => :model do

    describe "#create" do

        let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :risk_tolerance => 5) }

        let(:account) { user.accounts.create(:name => ENV["account_name"], :available_balance => 1000, :asset_balance => 1000) }

        let!(:asset) { Asset.create(:ticker => "AAPL", :price => 100, :riskiness => 5) }

        context "when called with no params" do

            let(:transaction) { Transaction.create }

            it "doesn't create record" do
                expect { transaction }.to_not change { Transaction.count }
            end

            it "returns four errors" do
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

        end

        context "when called with description" do

            it "accepts Investment" do
                expect { account.transactions.create(:amount => 1000, :description => "Investment") }.to change { Transaction.count }.by 1
            end

            it "accepts Deposit" do
                # Changes by 2 because Account callback automatically generates Investment after deposit
                expect { account.transactions.create(:amount => 1000, :description => "Deposit") }.to change { Transaction.count }.by 2
            end

            it "accepts Withdrawal" do
                expect { account.transactions.create(:amount => 1000, :description => "Withdrawal") }.to change { Transaction.count }.by 1
            end

            it "accepts Asset Sale" do
                expect { account.transactions.create(:amount => 1000, :description => "Asset Sale") }.to change { Transaction.count }.by 1
            end

            it "rejects anything else" do
                expect { account.transactions.create(:amount => 1000, :description => "anything else") }.to_not change { Transaction.count }
            end

        end

        context "when called with excessive Withdrawal" do

            let(:transaction) { account.transactions.create(:amount => 100000, :description => "Withdrawal") }

            it "doesn't create record" do
                expect { transaction }.to_not change { Transaction.count }
            end

            it "returns excessive withdrawal error" do
                expect(transaction.errors[:amount].first).to eql "exceeds available balance"
            end

        end

        context "when called with excessive Asset Sale" do

            let(:transaction) { account.transactions.create(:amount => 100000, :description => "Asset Sale") }

            it "doesn't create record" do
                expect { transaction }.to_not change { Transaction.count }
            end

            it "returns excessive asset sale error" do
                expect(transaction.errors[:amount].first).to eql "exceeds asset balance"
            end

        end

        context "when called with allowable Withdrawal" do

            let(:transaction) { account.transactions.create(:amount => 500, :description => "Withdrawal") }

            it "creates record" do
                expect { transaction }.to change { Transaction.count }.by 1
            end

            it "adjusts available balance" do
                expect { transaction }.to change { account.available_balance }.by -500
            end

        end

        context "when called with allowable Asset Sale" do

            let(:transaction) { account.transactions.create(:amount => 500, :description => "Asset Sale") }

            it "creates record" do
                expect { transaction }.to change { Transaction.count }.by 1
            end

            it "adjusts asset balance" do
                expect { transaction }.to change { account.asset_balance }.by -500
            end

            it "adjusts available balance" do
                expect { transaction }.to change { account.available_balance }.by 500
            end

            it "adjusts holding balance" do
                expect { transaction }.to change { account.holding.units }.by -5
            end

        end

        context "when called with allowable Investment" do

            let(:transaction) { account.transactions.create(:amount => 500, :description => "Investment") }

            it "creates record" do
                expect { transaction }.to change { Transaction.count }
            end

            it "adjusts asset balance" do
                expect { transaction }.to change { account.asset_balance }.by 500
            end

            it "adjusts available balance" do
                expect { transaction }.to change { account.available_balance }.by -500
            end

            it "adjusts holding units" do
                expect { transaction }.to change { account.holding.units }.by 5
            end

        end

        context "when investment amount < asset price" do

            let(:transaction) { account.transactions.create(:amount => 80, :description => "Investment") }

            it "doesn't create record" do
                expect { transaction }.to_not change { Transaction.count }
            end

            it "returns transaction < asset price error" do
                expect(transaction.errors[:amount].first).to eql "transaction must be worth at least one share"
            end

        end

        context "when asset sale amount < asset price" do
            
            let(:transaction) { account.transactions.create(:amount => 80, :description => "Asset Sale") }

            it "doesn't create record" do
                expect { transaction }.to_not change { Transaction.count }
            end

            it "returns transaction < asset price error" do
                expect(transaction.errors[:amount].first).to eql "transaction must be worth at least one share"
            end

        end

        context "when asset sale amount % price != 0" do

            let(:transaction) { account.transactions.create(:amount => 110, :description => "Asset Sale") }

            it "creates record" do
                expect { transaction }.to change { Transaction.count }
            end

            it "transacts whatever shares it can" do
                expect { transaction }.to change { account.holding.units }.by -1
            end

            it "keeps remainder in assets" do
                expect { transaction }.to change { account.asset_balance }.by -100
            end

            it "doesn't send remainder to cash" do
                expect { transaction }.to change { account.available_balance }.by 100
            end

        end

        context "when investment amount % price != 0" do

            let(:transaction) { account.transactions.create(:amount => 110, :description => "Investment") }

            it "creates record" do
                expect { transaction }.to change { Transaction.count }
            end

            it "transacts whatever shares it can" do
                expect { transaction }.to change { account.holding.units }.by 1
            end

            it "keeps remainder in cash" do
                expect { transaction }.to change { account.available_balance }.by -100
            end

            it "doesn't send remainder to asset" do
                expect { transaction }.to change { account.asset_balance }.by 100
            end

        end

        context "when called with deposit" do

            let(:transaction) { account.transactions.create(:amount => 1000, :description => "Deposit") }

            it "creates record" do
                expect { transaction }.to change { Transaction.count }.by 2
            end

            it "changes asset balance" do
                # Changes by 2000 because the account had 1000 to begin with and both get transacted
                expect { transaction }.to change { account.asset_balance }.by 2000
            end

        end

    end

end