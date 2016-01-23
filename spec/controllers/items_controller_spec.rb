require "rails_helper"

RSpec.describe ItemsController, type: :controller do
  let(:product) { FactoryGirl.create(:product) }

  describe "#new" do
    before do
      get :new, product_id: product.id
    end

    it "assigns @product" do
      expect(assigns(:product)).to eq(product)
    end

    it "assigns @item" do
      expect(assigns(:item)).to be_instance_of(Item)
    end

    it "renders the :new view" do
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "success" do
      let!(:items_count) { product.items.count }

      before do
        post :create, product_id: product.id, item: {
          size: "M",
          color: "burgundy",
          status: "in"
        }
      end

      it "adds the new item to product" do
        expect(product.items.count).to eq(items_count + 1)
      end

      it "redirects to 'product_item_path'" do
        expect(response.status).to be(302)
        expect(response.location).to match(/\/products\/\d+\/items\/\d+/)
      end
    end

    context "failed validations" do
      before do
        # create blank item (fails validations)
        post :create, product_id: product.id, item: {
          size: nil,
          color: nil,
          status: nil
        }
      end

      it "displays an error message" do
        expect(flash[:error]).to be_present
      end

      it "redirects to 'new_product_item_path'" do
        expect(response.status).to be(302)
        expect(response).to redirect_to(new_product_item_path(product))
      end
    end
  end

  describe "#show" do
    let(:item) { FactoryGirl.create(:item) }
    before do
      product.items << item
      get :show, product_id: product.id, id: item.id
    end

    it "assigns @product" do
      expect(assigns(:product)).to eq(product)
    end

    it "assigns @item" do
      expect(assigns(:item)).to eq(item)
    end

    it "renders the :show view" do
      expect(response).to render_template(:show)
    end
  end

  describe "#edit" do
    let(:item) { FactoryGirl.create(:item) }
    before do
      product.items << item
      get :edit, product_id: product.id, id: item.id
    end

    it "assigns @product" do
      expect(assigns(:product)).to eq(product)
    end

    it "assigns @item" do
      expect(assigns(:item)).to eq(item)
    end

    it "should render the :edit view" do
      expect(response).to render_template(:edit)
    end
  end

  describe "#update" do
    let(:item) { FactoryGirl.create(:item) }
    before do
      product.items << item
    end

    context "success" do
      let(:new_item_hash) do
        {
          size: 'M',
          color: 'burgundy',
          status: 'sold'
        }
      end

      before do
        put :update, product_id: product.id, id: item.id, item: new_item_hash

        # reload @item to get changes from :update
        item.reload
      end

      it "updates the item in the database" do
        expect(item.size).to eq(new_item_hash[:size])
        expect(item.color).to eq(new_item_hash[:color])
        expect(item.status).to eq(new_item_hash[:status])
      end

      it "redirects to 'product_item_path'" do
        expect(response.status).to be(302)
        expect(response).to redirect_to(product_item_path(product, item))
      end
    end

    context "failed validations" do
      before do
        # update with blank item params (fails validations)
        put :update, product_id: product.id, id: item.id, item: {
          size: nil,
          color: nil,
          status: nil
        }
      end

      it "displays an error message" do
        expect(flash[:error]).to be_present
      end

      it "redirects to 'edit_product_item_path'" do
        expect(response).to redirect_to(edit_product_item_path(product, item))
      end
    end
  end

  describe "#destroy" do
    before do
      item = FactoryGirl.create(:item)
      product.items << item
      @items_count = product.items.count
      delete :destroy, product_id: product.id, id: item.id
    end

    it "removes product's item from the database" do
      expect(product.items.count).to eq(@items_count - 1)
    end

    it "redirects to 'product_path'" do
      expect(response.status).to be(302)
      expect(response).to redirect_to(product_path(product))
    end
  end
end
