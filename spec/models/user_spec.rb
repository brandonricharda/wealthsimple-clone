require 'rails_helper'

RSpec.describe User, :type => :model do

    describe "#create" do

        context "when called without inputs" do
            it "doesn't create record" do
                expect { User.create }.to_not change { User.count }
            end
        end

        context "when called with just name" do
            it "doesn't create record" do
                expect { User.create(:name => ENV["valid_name"]) }.to_not change { User.count }
            end
        end

        context "when called with just email" do
            it "doesn't create record" do
                expect { User.create(:email => ENV["valid_email"]) }.to_not change { User.count }
            end
        end

        context "when called with just password" do
            it "doesn't create record" do
                expect { User.create(:password => ENV["password"]) }.to_not change { User.count }
            end
        end

        context "when called with just name and email" do
            it "doesn't create record" do
                expect { User.create(
                    :name => ENV["valid_name"],
                    :email => ENV["valid_email"]
                ) }.to_not change { User.count }
            end
        end

        context "when called with just name and password" do
            it "doesn't create record" do
                expect { User.create(
                    :name => ENV["valid_name"], 
                    :password => ENV["password"]
                ) }.to_not change { User.count }
            end
        end

        context "when called with email and password" do

            let(:user) { User.create(
                :email => ENV["valid_email"],
                :password => ENV["password"]
            ) }

            it "creates record" do
                expect(user.id).to_not eql nil
            end

            it "sets default risk tolerance to 0" do
                expect(user.risk_tolerance).to eql 0
            end

            it "sets default time horizon to 10" do
                expect(user.time_horizon).to eql 10
            end
            
        end

        context "when called with full params" do

            let(:user) { User.create(
                :name => ENV["valid_name"],
                :email => ENV["valid_email"],
                :password => ENV["password"]
            ) }

            it "creates record" do
                expect(user.id).to_not eql nil
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