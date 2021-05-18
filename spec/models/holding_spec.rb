require 'rails_helper'

RSpec.describe Holding, :type => :model do

    describe "#create" do

        let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :risk_tolerance => 1) }

        let(:account) { user.accounts.create(:name => ENV["account_name"], :available_balance => 100) }

        let(:stock) { Asset.create(:ticker => "SPY", :price => 100, :riskiness => 1) }

        context "when called with no params" do

            let(:holding) { Holding.create }

            it "doesn't create record" do
                expect { holding }.to_not change { Holding.count }
            end

            it "returns three errors" do
                expect(holding.errors.count).to eql 3
            end

            it "returns blank units error" do
                expect(holding.errors[:base].first).to eql "Transaction must specify number of units."
            end

            it "returns blank account error" do
                expect(holding.errors[:account].first).to eql "must exist"
            end

            it "returns blank asset error" do
                expect(holding.errors[:asset].first).to eql "must exist"
            end

        end

        context "when called with insufficient balance" do

            let(:holding) { account.holdings.create(:asset_id => stock.id, :account_id => account.id, :units => 100) }

            it "doesn't create record" do
                expect { holding }.to_not change { Holding.count }
            end

            it "returns one error" do
                expect(holding.errors.count).to eql 1
            end

            it "returns insufficient balance error" do
                expect(holding.errors[:base].first).to eql "Transaction amount exceeds available balance."
            end

        end

        context "when added to user with wrong risk tolerance" do

            let(:risky_stock) { Asset.create(:ticker => "TSLA", :price => 100, :riskiness => 5) }

            let(:holding) { account.holdings.create(:asset_id => risky_stock.id, :units => 1) }

            it "doesn't create record" do
                expect { holding }.to_not change { Holding.count }
            end

            it "returns one error" do
                expect(holding.errors.count).to eql 1
            end

            it "returns excessive riskiness error" do
                expect(holding.errors[:base].first).to eql "Transaction exceeds user's risk tolerance."
            end

        end

        context "when added with wrong risk and NSF" do

            let(:risky_stock) { Asset.create(:ticker => "TSLA", :price => 100, :riskiness => 5) }

            let(:holding) { account.holdings.create(:asset_id => risky_stock.id, :units => 100) }

            it "doesn't create record" do
                expect { holding }.to_not change { Holding.count }
            end

            it "returns two errors" do
                expect(holding.errors.count).to eql 2
            end

            it "returns excessive riskiness error" do
                expect(holding.errors[:base].first).to eql "Transaction exceeds user's risk tolerance."
            end

            it "returns insufficient balance error" do
                expect(holding.errors[:base].last).to eql "Transaction amount exceeds available balance."
            end

        end

        context "when added to user with no risk tolerance" do

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"]) }

            let(:account) { user.accounts.create(:name => ENV["account_name"], :available_balance => 100) }

            let(:stock) { Asset.create(:ticker => "AAPL", :price => 100, :riskiness => 5) }

            let(:holding) { account.holdings.create(:asset_id => stock.id, :units => 10) }

            it "doesn't create record" do
                expect { holding }.to_not change { Holding.count }
            end

            it "returns one error" do
                expect(holding.errors.count).to eql 1
            end

            it "returns no risk tolerance error" do
                expect(holding.errors[:base].first).to eql "User has no set risk tolerance."
            end

        end

        context "when called with correct params" do

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :risk_tolerance => 5) }

            let(:account) { user.accounts.create(:name => ENV["account_name"], :available_balance => 1000) }

            let(:stock) { Asset.create(:ticker => "AAPL", :price => 100, :riskiness => 5) }

            let(:holding) { account.holdings.create(:asset_id => stock.id, :units => 10) }

            it "creates record" do
                expect { holding }.to change { Holding.count }
            end

            it "returns zero errors" do
                expect(holding.errors.count).to eql 0
            end

            it "adjusts available balance correctly" do
                expect { holding }.to change { account.available_balance }.by -1000
            end

            it "adjusts asset balance correctly" do
                expect { holding }.to change { account.asset_balance }.by 1000
            end

        end

    end

    describe "valuation" do

        context "when called" do

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"]) }

            let(:account) { user.accounts.create(:name => ENV["account_name"], :available_balance => 100) }

            let(:stock) { Asset.create(:ticker => "AAPL", :price => 100, :riskiness => 5) }

            let(:holding) { account.holdings.create(:asset_id => stock.id, :units => 10) }

            it "returns correct valuation of holding" do
                expect(holding.valuation).to eql 1000
            end

        end

    end

end
