require 'rails_helper'

RSpec.describe Holding, :type => :model do

    describe "create" do

        let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :risk_tolerance => 5) }

        let(:account) { user.accounts.create(:name => ENV["account_name"], :available_balance => 1000) }

        let(:stock) { Asset.create(:ticker => "SPY", :price => 100, :riskiness => 5) }

        context "when called with no params" do

            let(:holding) { Holding.create }

            it "doesn't create record" do
                expect { holding }.to_not change { Holding.count }
            end

            it "returns three errors" do
                expect(holding.errors.count).to eql 3
            end

            it "returns blank units error" do
                expect(holding.errors[:units].first).to eql "can't be blank"
            end

            it "returns blank account error" do
                expect(holding.errors[:account].first).to eql "must exist"
            end

            it "returns blank asset error" do
                expect(holding.errors[:asset].first).to eql "must exist"
            end

        end

        context "when called with required params" do

            let(:holding) { account.create_holding(:asset_id => stock.id, :units => 10) }

            it "creates record" do
                expect { holding }.to change { Holding.count }
            end

            it "returns no errors" do
                expect(holding.errors.count).to eql 0
            end

        end

        context "when called with insufficient balance" do

            let(:holding) { account.create_holding(:asset_id => stock.id, :units => 1000) }

            it "doesn't create record" do
                expect { holding }.to_not change { Holding.count }
            end

            it "returns one error" do
                expect(holding.errors.count).to eql 1
            end

            it "returns transaction limit error" do
                expect(holding.errors[:units].first).to eql "exceeds available balance"
            end

        end

        context "when added to user without risk tolerance" do

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"]) }

            let(:account) { user.accounts.create(:name => ENV["account_name"], :available_balance => 1000) }

            let(:holding) { account.create_holding(:asset_id => stock.id, :units => 10) }

            it "doesn't create record" do
                expect { holding }.to_not change { Holding.count }
            end

            it "returns one error" do
                expect(holding.errors.count).to eql 1
            end

            it "returns risk tolerance missing error" do
                expect(holding.errors[:base].first).to eql "user risk tolerance missing"
            end

        end

        context "when too risky for user" do

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :risk_tolerance => 1) }

            let(:holding) { account.create_holding(:asset_id => stock.id, :units => 10) }

            it "doesn't create record" do
                expect { holding }.to_not change { Holding.count }
            end

            it "returns one error" do
                expect(holding.errors.count).to eql 1
            end

            it "returns excessive risk error" do
                expect(holding.errors[:base].first).to eql "exceeds user risk tolerance"
            end

        end

    end

    describe "valuation" do

        context "when called" do

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"]) }

            let(:account) { user.accounts.create(:name => ENV["account_name"], :available_balance => 100) }

            let(:stock) { Asset.create(:ticker => "AAPL", :price => 100, :riskiness => 5) }

            let(:holding) { account.create_holding(:asset_id => stock.id, :units => 10) }

            it "returns correct valuation of holding" do
                expect(holding.valuation).to eql 1000
            end

        end

    end

end
