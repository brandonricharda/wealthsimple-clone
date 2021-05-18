require 'rails_helper'

RSpec.describe Holding, :type => :model do

    describe "#create" do

        let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :risk_tolerance => 1) }

        let(:account) { user.accounts.create(:name => ENV["account_name"], :available_balance => 100) }

        let(:stock) { Asset.create(:ticker => "SPY", :price => 100, :riskiness => 1) }

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

            let(:holding) { account.holdings.create(:asset_id => risky_stock.id, :units => 10) }

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

    end

end
