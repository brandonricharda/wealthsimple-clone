require 'rails_helper'

RSpec.describe Asset, :type => :model do

    describe "#create" do

        context "when called without params" do

            let(:asset) { Asset.create }

            it "doesn't create record" do
                expect { asset }.to_not change { Asset.count }
            end

            it "returns five errors" do
                expect(asset.errors.count).to eql 5
            end

            it "returns ticker blank error" do
                expect(asset.errors[:ticker].first).to eql "can't be blank"
            end

            it "returns price blank error" do
                expect(asset.errors[:price].first).to eql "can't be blank"
            end

            it "returns price not number error" do
                expect(asset.errors[:price].last).to eql "is not a number"
            end

            it "returns riskiness blank error" do
                expect(asset.errors[:riskiness].first).to eql "can't be blank"
            end

            it "returns riskiness not number error" do
                expect(asset.errors[:riskiness].last).to eql "is not a number"
            end

        end

        context "when called with just price" do

            let(:asset) { Asset.create(:price => 100) }

            it "doesn't create record" do
                expect { asset }.to_not change { Asset.count }
            end

            it "returns three errors" do
                expect(asset.errors.count).to eql 3
            end

            it "returns ticker blank error" do
                expect(asset.errors[:ticker].first).to eql "can't be blank"
            end

            it "returns riskiness blank error" do
                expect(asset.errors[:riskiness].first).to eql "can't be blank"
            end

            it "returns riskiness not number error" do
                expect(asset.errors[:riskiness].last).to eql "is not a number"
            end

        end

        context "when called with just riskiness" do

            let(:asset) { Asset.create(:riskiness => 5) }

            it "doesn't create record" do
                expect { asset }.to_not change { Asset.count }
            end

            it "returns three errors" do
                expect(asset.errors.count).to eql 3
            end

            it "returns ticker blank error" do
                expect(asset.errors[:ticker].first).to eql "can't be blank"
            end

            it "returns price blank error" do
                expect(asset.errors[:price].first).to eql "can't be blank"
            end

            it "returns price not number error" do
                expect(asset.errors[:price].last).to eql "is not a number"
            end

        end

        context "when called with just ticker" do

            let(:asset) { Asset.create(:ticker => "AAPL") }
            
            it "doesn't create record" do
                expect { asset }.to_not change { Asset.count }
            end

            it "returns four errors" do
                expect(asset.errors.count).to eql 4
            end

            it "returns no price error" do
                expect(asset.errors[:price].first).to eql "can't be blank"
            end

            it "returns price not number error" do
                expect(asset.errors[:price].last).to eql "is not a number"
            end

            it "returns riskiness blank error" do
                expect(asset.errors[:riskiness].first).to eql "can't be blank"
            end

            it "returns riskiness not number error" do
                expect(asset.errors[:riskiness].last).to eql "is not a number"
            end

        end

        context "when called with just price and riskiness" do

            let(:asset) { Asset.create(:price => 100, :riskiness => 5) }

            it "doesn't create record" do
                expect { asset }.to_not change { Asset.count }
            end

            it "returns one error" do
                expect(asset.errors.count).to eql 1
            end

            it "returns ticker blank error" do
                expect(asset.errors[:ticker].first).to eql "can't be blank"
            end

        end

        context "when called with just price and ticker" do

            let(:asset) { Asset.create(:price => 100, :ticker => "AAPL") }

            it "doesn't create record" do
                expect { asset }.to_not change { Asset.count }
            end

            it "returns two errors" do
                expect(asset.errors.count).to eql 2
            end

            it "returns riskiness blank error" do
                expect(asset.errors[:riskiness].first).to eql "can't be blank"
            end

            it "returns riskiness not number error" do
                expect(asset.errors[:riskiness].last).to eql "is not a number"
            end

        end

        context "when called with just riskiness and ticker" do

            let(:asset) { Asset.create(:riskiness => 5, :ticker => "AAPL") }

            it "doesn't create record" do
                expect { asset }.to_not change { Asset.count }
            end

            it "returns two errors" do
                expect(asset.errors.count).to eql 2
            end

            it "returns no price error" do
                expect(asset.errors[:price].first).to eql "can't be blank"
            end

            it "returns price not number error" do
                expect(asset.errors[:price].last).to eql "is not a number"
            end

        end

        context "when called with full params" do

            let(:asset) { Asset.create(:ticker => "AAPL", :price => 100, :riskiness => 5) }

            it "creates record" do
                expect { asset }.to change { Asset.count }
            end

            it "returns no errors" do
                expect(asset.errors.count).to eql 0
            end

        end

        context "when called with riskiness > 5" do

            let(:asset) { Asset.create(:ticker => "AAPL", :price => 100, :riskiness => 6) }

            it "doesn't create record" do
                expect { asset }.to_not change { Asset.count }
            end

            it "returns one error" do
                expect(asset.errors.count).to eql 1
            end

            it "returns riskiness outside range" do
                expect(asset.errors[:riskiness].first).to eql "must be less than or equal to 5"
            end

        end

        context "when called with riskiness < 1" do

            let(:asset) { Asset.create(:ticker => "AAPL", :price => 100, :riskiness => 0) }

            it "doesn't create record" do
                expect { asset }.to_not change { Asset.count }
            end

            it "returns one error" do
                expect(asset.errors.count).to eql 1
            end

            it "returns riskiness outside range" do
                expect(asset.errors[:riskiness].first).to eql "must be greater than or equal to 1"
            end

        end

        context "when called with price of 0" do

            let(:asset) { Asset.create(:ticker => "AAPL", :price => 0, :riskiness => 5) }

            it "doesn't create record" do
                expect { asset }.to_not change { Asset.count }
            end

            it "returns one error" do
                expect(asset.errors.count).to eql 1
            end

            it "returns price below 1 error" do
                expect(asset.errors[:price].first).to eql "must be greater than or equal to 1"
            end

        end

    end

end
