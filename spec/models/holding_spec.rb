require 'rails_helper'

RSpec.describe Holding, :type => :model do

    describe "#create" do

        let(:user) {
            User.create(
                :name => ENV["valid_name"],
                :email => ENV["valid_email"],
                :password => ENV["password"],
                :risk_tolerance => 1
            )
        }

        let(:account) {
            user.accounts.create(
                :name => ENV["account_name"],
                :available_balance => 10000
            )
        }

        let(:stock) {
            Asset.create(
                :ticker => "SPY",
                :price => 100,
                :riskiness => 1
            )
        }

        context "when called with insufficient balance" do
            it "doesn't create record" do
                expect{ Holding.create(
                    :asset_id => stock.id,
                    :account_id => account.id,
                    :units => 1000
                ) }.to_not change { Holding.count }
            end
        end

        context "when added to user with wrong risk tolerance" do

            let(:risky_stock) { Asset.create(
                :ticker => "TSLA",
                :price => 100,
                :riskiness => 5
            ) }

            it "doesn't create record" do
                expect { account.holdings.create(
                    :asset_id => risky_stock.id,
                    :units => 10
                ) }.to_not change { account.holdings.count }
            end
        end

    end

end
