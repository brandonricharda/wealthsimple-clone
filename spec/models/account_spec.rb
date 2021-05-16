require 'rails_helper'

RSpec.describe Account, :type => :model do

    after(:all) { User.destroy_all }

    describe "#new" do

        context "when called without name" do
            it "responds invalid" do
                expect(Account.new).to_not be_valid
            end
        end

    end

    describe "#create" do

        let(:user) {
            User.create(
                :name => ENV["valid_name"],
                :email => ENV["valid_email"],
                :password => ENV["password"]
            )
        }

        context "when called with valid input" do
            it "sets balance to 0 by default" do
                expect(Account.create(
                  :name => ENV["account_name"],
                  :user_id => user.id
                ).available_balance).to eql 0
            end
        end

    end

    describe ".portfolio" do

        context "when called on account without portfolio" do
            it "returns nil" do
                expect(Account.create(
                    :name => ENV["account_name"]
                ).portfolio).to eql nil
            end
        end

    end

    describe ".update_available_balance" do

        let(:user) {
            User.create(
                :name => ENV["valid_name"],
                :email => ENV["valid_email"],
                :password => ENV["password"]
            )
        }

        let(:account) {
            user.accounts.create(
                :name => ENV["account_name"],
                :user_id => user.id ,
                :available_balance => 1000000
            )
        }

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

    end

    describe ".update_asset_balance" do

        let(:user) {
            User.create(
                :name => ENV["valid_name"],
                :email => ENV["valid_email"],
                :password => ENV["password"]
            )
        }

        let(:account) {
            user.accounts.create(
                :name => ENV["account_name"],
                :user_id => user.id ,
                :available_balance => 1000000
            )
        }

        context "when called with negative number" do
            it "increases asset balance" do
                expect { account.update_asset_balance(-10000) }.to change { account.asset_balance }.by(-10000)
            end
        end

        context "when called with positive number" do
            it "increases asset balance" do
                expect { account.update_asset_balance(10000) }.to change { account.asset_balance }.by(10000)
            end
        end
    end

end