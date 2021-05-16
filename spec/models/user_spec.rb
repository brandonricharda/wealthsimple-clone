require 'rails_helper'

RSpec.describe User, :type => :model do

    describe "#new" do

        context "when called without inputs" do
            it "responds invalid" do
                expect(User.new).to_not be_valid
            end
        end

        context "when called with just name" do
            it "responds invalid" do
                expect(User.new(
                    :name => ENV["valid_name"]
                )).to_not be_valid
            end
        end

        context "when called with name and email" do
            it "responds invalid" do
                expect(User.new(
                    :name => ENV["valid_name"],
                    :email => ENV["valid_email"],
                )).to_not be_valid
            end
        end

        context "when called with all data" do
            it "responds valid" do
                expect(User.new(
                    :name => ENV["valid_name"],
                    :email => ENV["valid_email"],
                    :password => ENV["password"]
                )).to be_valid
            end
        end

    end

    describe "#create" do

        context "when successful" do

            let(:user) { User.create(
                :name => ENV["valid_name"],
                :email => ENV["valid_email"],
                :password => ENV["password"]
            ) }
            
            it "sets default risk tolerance to 0" do
                expect(user.risk_tolerance).to eql 0
            end

            it "sets default time horizon to 10" do
                expect(user.time_horizon).to eql 10
            end
        end

    end

    describe ".accounts" do

        context "when called on new user" do
            it "returns empty array" do
                expect(User.create(
                    :name => ENV["valid_name"],
                    :email => ENV["valid_email"]
                ).accounts.count).to eql 0
            end
        end

    end

end