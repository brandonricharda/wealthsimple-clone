require 'rails_helper'

RSpec.describe Account, :type => :model do

    describe "#create" do

        let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :risk_tolerance => 5) }

        context "when called without name" do

            let(:account) { user.accounts.create }

            it "doesn't create record" do
                expect { account }.to_not change { Account.count }
            end

            it "returns one error" do
                expect(account.errors.count).to eql 1
            end

            it "returns blank name error" do
                expect(account.errors[:name].first).to eql "can't be blank"
            end

        end

        context "when called with name" do

            let(:account) { user.accounts.create(:name => ENV["account_name"]) }
            let!(:asset) { Asset.create(:ticker => "AAPL", :price => 100, :riskiness => 5) }

            it "creates record" do
                expect { account }.to change { Account.count }.by 1
            end

            it "returns no errors" do
                expect(account.errors.count).to eql 0
            end

            it "sets default available balance of 0" do
                expect(account.available_balance).to eql 0
            end

            it "sets default asset balance of 0" do
                expect(account.asset_balance).to eql 0
            end

            it "creates holding" do
                expect { account }.to change { Holding.count }
            end

        end

        context "when called with name and balances" do

            let(:account) { user.accounts.create(:name => ENV["account_name"], :available_balance => 1000, :asset_balance => 1000) }

            it "creates record" do
                expect { account }.to change { Account.count }.by 1
            end

            it "returns no errors" do
                expect(account.errors.count).to eql 0
            end

            it "sets available balance to input" do
                expect(account.available_balance).to eql 1000
            end

            it "sets asset balance to input" do
                expect(account.asset_balance).to eql 1000
            end

        end

    end

    describe ".update_available_balance" do

        let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :risk_tolerance => 5) }

        let(:account) { user.accounts.create(:name => ENV["account_name"], :available_balance => 1000000) }

        context "when called with negative number" do
            it "reduces available balance" do
                expect { account.update_available_balance(-10000) }.to change { account.available_balance }.by(-10000)
            end
        end

        context "when called with positive number" do
            it "increases available balance" do
                expect { account.update_available_balance(10000) }.to change { account.available_balance }.by(10000)
            end
        end

        context "when called with large negative number" do
            it "prohibits negative balance" do
                expect(account.update_available_balance(-1000000000)).to eql [false, "Transaction exceeds available balance"]
            end
        end

    end

    describe ".update_asset_balance" do

        let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :risk_tolerance => 5) }

        let(:account) { user.accounts.create(:name => ENV["account_name"], :asset_balance => 1000000) }

        context "when called with negative number" do
            it "decreases asset balance" do
                expect { account.update_asset_balance(-10000) }.to change { account.asset_balance }.by(-10000)
            end
        end

        context "when called with positive number" do
            it "increases asset balance" do
                expect { account.update_asset_balance(10000) }.to change { account.asset_balance }.by(10000)
            end
        end

        context "when called with large negative number" do
            it "prohibits negative balance" do
                expect(account.update_asset_balance(-1000000000)).to eql [false, "Transaction exceeds available balance"]
            end
        end
    end

    describe ".rebalance" do

        let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :risk_tolerance => 5) }

        let(:account) { user.accounts.create(:name => ENV["account_name"], :available_balance => 1000) }

        let(:stock) { Asset.create(:ticker => "SPY", :price => 1, :riskiness => 5) }

        let!(:holding) { account.create_holding(:asset_id => stock.id, :units => 0) }

        context "when called on account with available balance" do
            it "buys however many stocks it can" do
                expect { account.rebalance }.to change { account.available_balance }.by -1000
            end
        end

        context "when called on account with no balance" do

            let(:account) { user.accounts.create(:name => ENV["account_name"]) }

            it "doesn't do anything" do
                expect { account.rebalance }.to_not change { account.available_balance }
            end
            
        end

    end

    describe ".add_holding" do

    end

end