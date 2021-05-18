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

            let(:user) { User.create(:name => ENV["valid_name"], :email => ENV["valid_email"], :password => ENV["password"], :risk_tolerance => 1) }

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

    end

end