require 'rails_helper'

RSpec.describe User, :type => :model do
    
    describe "#create" do

        context "when called with no params" do

            let(:user) { User.create }

            it "doesn't create record" do
                expect { user }.to_not change { User.count }
            end

            it "returns three errors" do
                expect(user.errors.count).to eql 3
            end

            it "returns blank email error" do
                expect(user.errors[:email].first).to eql "can't be blank"
            end

            it "returns blank password error" do
                expect(user.errors[:password].first).to eql "can't be blank"
            end

            it "returns blank name error" do
                expect(user.errors[:name].first).to eql "can't be blank"
            end

        end

        context "when called with required params" do

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"]) }

            it "creates record" do
                expect { user }.to change { User.count }.by 1
            end

            it "returns zero errors" do
                expect(user.errors.count).to eql 0
            end

        end

        context "when called with risk tolerance < 1" do

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :risk_tolerance => 0) }

            it "doesn't create record" do
                expect { user }.to_not change { User.count }
            end

            it "returns one error" do
                expect(user.errors.count).to eql 1
            end

            it "returns risk tolerance < 1 error" do
                expect(user.errors[:risk_tolerance].first).to eql "must be greater than or equal to 1"
            end

        end

        context "when called with risk tolerance > 5" do

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :risk_tolerance => 6) }

            it "doesn't create record" do
                expect { user }.to_not change { User.count }
            end

            it "returns one error" do
                expect(user.errors.count).to eql 1
            end

            it "returns risk tolerance > 5 error" do
                expect(user.errors[:risk_tolerance].first).to eql "must be less than or equal to 5"
            end

        end

        context "when called with string num risk tolerance" do

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :risk_tolerance => "5") }

            it "creates record" do
                expect { user }.to change { User.count }
            end

            it "converts string properly" do
                expect(user.risk_tolerance).to eql 5
            end

        end

        context "when called with text risk tolerance" do

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :risk_tolerance => "test") }

            it "doesn't create record" do
                expect { user }.to_not change { User.count }
            end

            it "returns risk tolerance not num error" do
                expect(user.errors[:risk_tolerance].first).to eql "is not a number"
            end

        end

        context "when called with time_horizon > 30" do

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :time_horizon => 40) }

            it "doesn't create record" do
                expect { user }.to_not change { User.count }
            end

            it "returns time horizon > 30 error" do
                expect(user.errors[:time_horizon].first).to eql "must be less than or equal to 30"
            end

        end

        context "when called with time horizon < 1" do

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :time_horizon => 0) }

            it "doesn't create record" do
                expect { user }.to_not change { User.count }
            end

            it "returns time horizon < 1 error" do
                expect(user.errors[:time_horizon].first).to eql "must be greater than or equal to 1"
            end

        end

        context "when called with string num time horizon" do

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :time_horizon => "1") }

            it "creates record" do
                expect { user }.to change { User.count }
            end

            it "converts string into integer" do
                expect(user.time_horizon).to eql 1
            end

        end

        context "when called with text time horizon" do

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :time_horizon => "test") }

            it "doesn't create record" do
                expect { user }.to_not change { User.count }
            end

            it "returns time horizon not num error" do
                expect(user.errors[:time_horizon].first).to eql "is not a number"
            end

        end

    end

end