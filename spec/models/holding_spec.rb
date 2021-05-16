require 'rails_helper'

RSpec.describe Holding, :type => :model do

    describe "#new" do

        let(:stock) {
            Asset.create(
                :ticker => "AAPL",
                :price => 123
            )
        }

        let(:user) {
            User.create(
                :name => ENV["valid_name"],
                :email => ENV["valid_email"],
                :password => ENV["password"]
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
                    :asset_id => stock.id,
                )).to_not be_valid
            end
        end

        context "when called with valid inputs" do
            it "responds valid" do
                expect(Holding.new(
                    :asset_id => stock.id,
                    :user_id => user.id
                )).to be_valid
            end
        end
    end

end
