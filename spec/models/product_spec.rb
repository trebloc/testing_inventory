require "rails_helper"

RSpec.describe Product, type: :model do

  describe "methods" do
    describe "#margin" do
      let(:product) { FactoryGirl.create(:product) }

      it "should calculate product's retail margin" do
        retail_margin = (product.retail - product.wholesale) / product.retail
        expect(product.margin).to eq(retail_margin)
      end
    end

    describe "sell_through" do
      let(:product) { FactoryGirl.create(:product) }

      before do
        statuses = ["sold", "in", "out", "sold", "clearanced"]
        statuses.each do |status|
          product.items.create(size: "M", color: "burgundy", status: status)
        end

        total_items = product.items.count
        items_sold = product.items.where(status: "sold").count
        @sell_through = items_sold / total_items
      end

      it "should calculate product's overall sell-through rate" do
        expect(product.sell_through).to eq(@sell_through)
      end
    end
  end

end
