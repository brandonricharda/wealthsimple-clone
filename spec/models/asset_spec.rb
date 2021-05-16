require 'rails_helper'

RSpec.describe Asset, :type => :model do

    describe "#create" do

        context "when called without params" do
            it "doesn't create record" do
                expect { Asset.create }.to_not change { Asset.count }
            end
        end

        context "when called with just price" do
            it "doesn't create record" do
                expect { Asset.create(
                    :price => 100
                ) }.to_not change { Asset.count }
            end
        end

        context "when called with just riskiness" do
            it "doesn't create record" do
                expect { Asset.create(
                    :riskiness => 5
                ) }.to_not change { Asset.count }
            end
        end

        context "when called with just ticker" do
            it "doesn't create record" do
                expect { Asset.create(
                    :ticker => "AAPL"
                ) }.to_not change { Asset.count }
            end
        end

        context "when called with just price and riskiness" do
            it "doesn't create record" do
                expect { Asset.create(
                    :price => 100,
                    :riskiness => 5
                ) }.to_not change { Asset.count }
            end
        end

        context "when called with just price and ticker" do
            it "doesn't create record" do
                expect { Asset.create(
                    :price => 100,
                    :ticker => "AAPL"
                ) }
            end
        end

        context "when called with just riskiness and ticker" do
            it "doesn't create record" do
                expect { Asset.create(
                    :riskiness => 5,
                    :ticker => "AAPL"
                ) }.to_not change { Asset.count }
            end
        end

        context "when called with full params" do
            it "creates record" do
                expect { Asset.create(
                    :ticker => "AAPL",
                    :price => 100,
                    :riskiness => 5
                ) }.to change { Asset.count }.by 1
            end
        end

        context "when called with riskiness > 5" do
            it "doesn't create record" do
                expect { Asset.create(
                    :ticker => "AAPL",
                    :price => 100,
                    :riskiness => 6
                ) }.to_not change { Asset.count }
            end
        end

        context "when called with riskiness < 1" do
            it "doesn't create record" do
                expect { Asset.create(
                    :ticker => "AAPL",
                    :price => 100,
                    :riskiness => 0
                ) }.to_not change { Asset.count }
            end
        end

    end

end
