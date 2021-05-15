require 'rails_helper'

RSpec.describe Asset, :type => :model do

    describe "#new" do

        context "when initialized without data" do
            it "responds invalid" do
                expect(Asset.new).to_not be_valid
            end
        end

        context "when initialized without ticker" do
            it "responds invalid" do
                expect(Asset.new(
                    :price => 123
                )).to_not be_valid
            end
        end

        context "when initialized with data" do
            it "responds valid" do
                expect(Asset.new(
                    :price => 123,
                    :ticker => "AAPL"
                )).to be_valid
            end
        end

    end

end
