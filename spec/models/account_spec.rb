require 'rails_helper'

RSpec.describe Account, :type => :model do

    describe "#create" do

        let(:user) {
            User.create(
                :name => ENV["valid_name"],
                :email => ENV["valid_email"],
                :password => ENV["password"]
            )
        }

        context "when called without params" do
            it "doesn't create record" do
                expect { user.accounts.create }.to_not change { Account.count }
            end
        end

        context "when called with name" do
            it "creates record" do
                expect { user.accounts.create(
                    :name => ENV["account_name"]
                ) }.to change { Account.count }.by 1
            end
        end

        context "when called with full params" do

            let(:account) { user.accounts.create(
                :name => ENV["account_name"]
            ) }
            
            it "creates record" do
                expect { account }.to change { Account.count }.by 1
            end

            it "sets default available balance of 0" do
                expect(account.available_balance).to eql 0
            end

            it "sets default asset balance of 0" do
                expect(account.asset_balance).to eql 0
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

        context "when called with large negative number" do
            it "prohibits negative balance" do
                expect { account.update_available_balance(-1000000000) }.to_not change { account.available_balance }
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
                :asset_balance => 1000000
            )
        }

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
                expect { account.update_asset_balance(-1000000000) }.to_not change { account.asset_balance }
            end
        end
    end

end