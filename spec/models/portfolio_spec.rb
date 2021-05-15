require 'rails_helper'

RSpec.describe Portfolio, :type => :model do

    describe "#new" do
        context "when pushed with no risk tolerance" do
            it "responds invalid" do
                expect(Portfolio.new).to_not be_valid
            end
        end
    end

end
