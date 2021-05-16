require 'rails_helper'

RSpec.describe Asset, :type => :model do

    describe "#new" do

        context "when called without data" do
            it "responds invalid" do
                expect(Asset.new).to_not be_valid
            end
        end

        context "when called without ticker" do
            it "responds invalid" do
                expect(Asset.new(
                    :price => 100
                )).to_not be_valid
            end
        end

        context "when called with data" do
            it "responds valid" do
                expect(Asset.new(
                    :price => 100,
                    :ticker => "AAPL"
                )).to be_valid
            end
        end

    end

end
