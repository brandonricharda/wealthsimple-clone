require 'rails_helper'

RSpec.describe Account, :type => :model do

    describe "#new" do

        context "when initialized without name" do
            it "responds invalid" do
                expect(Account.new).to_not be_valid
            end
        end

    end

    describe "#create" do

        context "when initialized with valid input" do
            it "sets balance to 0.0 by default" do
                expect(Account.create(
                  :name => ENV["account_name"]
                ).balance).to eql 0.0
            end
        end

    end

    describe ".user" do

        context "when initialized on non-associated account" do
            it "returns nil" do
                expect(Account.create(
                    :name => ENV["account_name"]
                ).user).to eql nil
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

end