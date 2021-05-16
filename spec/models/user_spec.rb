require 'rails_helper'

RSpec.describe User, :type => :model do

    describe "#create" do

        context "when called without inputs" do

            let(:user) { User.create }

            it "doesn't create record" do
                expect { user }.to_not change { User.count }
            end

            it "returns two errors" do
                expect(user.errors.count).to eql 2
            end

            it "returns blank email error" do
                expect(user.errors[:email].first).to eql "can't be blank"
            end

            it "returns blank password error" do
                expect(user.errors[:password].first).to eql "can't be blank"
            end

        end

        context "when called with just name" do

            let(:user) { User.create(:name => ENV["valid_name"]) }

            it "doesn't create record" do
                expect { user }.to_not change { User.count }
            end

            it "returns two errors" do
                expect(user.errors.count).to eql 2
            end

            it "returns blank email error" do
                expect(user.errors[:email].first).to eql "can't be blank"
            end

            it "returns blank password error" do
                expect(user.errors[:password].first).to eq "can't be blank"
            end

        end

        context "when called with just email" do

            let(:user) { User.create(:email => ENV["valid_email"]) }

            it "doesn't create record" do
                expect { user }.to_not change { User.count }
            end

            it "returns one error" do
                expect(user.errors.count).to eql 1
            end

            it "returns blank password error" do
                expect(user.errors[:password].first).to eql "can't be blank"
            end

        end

        context "when called with just password" do

            let(:user) { User.create(:password => ENV["password"]) }

            it "doesn't create record" do
                expect { user }.to_not change { User.count }
            end

            it "returns one error" do
                expect(user.errors.count).to eql 1
            end

            it "returns blank email error" do
                expect(user.errors[:email].first).to eql "can't be blank"
            end

        end

        context "when called with just name and email" do

            let(:user) { User.create(:name => ENV["name"], :email => ENV["valid_email"]) }

            it "doesn't create record" do
                expect { user }.to_not change { User.count }
            end

            it "returns one error" do
                expect(user.errors.count).to eql 1
            end

            it "returns blank password error" do
                expect(user.errors[:password].first).to eql "can't be blank"
            end

        end

        context "when called with just name and password" do

            let(:user) { User.create(:name => ENV["valid_name"], :password => ENV["password"]) }

            it "doesn't create record" do
                expect { user }.to_not change { User.count }
            end

            it "returns one error" do
                expect(user.errors.count).to eql 1
            end

            it "returns blank email error" do
                expect(user.errors[:email].first).to eql "can't be blank"
            end

        end

        context "when called with email and password" do

            let(:user) { User.create(:email => ENV["valid_email"], :password => ENV["password"]) }

            it "creates record" do
                expect { user }.to change { User.count }
            end

            it "returns no errors" do
                expect(user.errors.count).to eql 0
            end

            it "sets default risk tolerance to 0" do
                expect(user.risk_tolerance).to eql 0
            end

            it "sets default time horizon to 10" do
                expect(user.time_horizon).to eql 10
            end
            
        end

        context "when called with full params" do

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"]) }

            it "creates record" do
                expect(user.id).to_not eql nil
            end

            it "returns no errors" do
                expect(user.errors.count).to eql 0
            end
            
            it "sets default risk tolerance to 0" do
                expect(user.risk_tolerance).to eql 0
            end

            it "sets default time horizon to 10" do
                expect(user.time_horizon).to eql 10
            end

        end

    end

end