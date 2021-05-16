require 'rails_helper'

RSpec.describe Holding, :type => :model do

    describe "#new" do

        let(:stock) {
            Asset.create(
                :ticker => "AAPL",
                :price => 100
            )
        }

        let(:user) {
            User.create(
                :name => ENV["valid_name"],
                :email => ENV["valid_email"],
                :password => ENV["password"]
            )
        }

        let(:large_account) {
            user.accounts.create(
                :name => ENV["valid_name"],
                :available_balance => ENV["large_balance"]
            )
        }

        let(:small_account) {
            user.accounts.create(
                :name => ENV["valid_name"],
                :available_balance => ENV["small_balance"]
            )
        }

        context "when called without inputs" do
            it "responds invalid" do
                expect(Holding.new).to_not be_valid
            end
        end

        context "when called with just stock" do
            it "responds invalid" do
                expect(Holding.new(
                    :asset_id => stock.id
                )).to_not be_valid
            end
        end

        context "when called with just account" do
            it "responds invalid" do
                expect(Holding.new(
                    :account_id => large_account.id
                )).to_not be_valid
            end
        end

        context "when called with valid inputs" do
            it "responds valid" do
                expect(Holding.new(
                    :asset_id => stock.id,
                    :account_id => large_account.id,
                    :units => 5
                )).to be_valid
            end
        end

        context "when called with insufficient balance" do
            it "responds invalid" do
                expect(Holding.new(
                    :asset_id => stock.id,
                    :account_id => small_account.id,
                    :units => 10
                )).to_not be_valid
            end
        end
    end

end
