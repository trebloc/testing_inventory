require "rails_helper"

RSpec.describe ProductsController, type: :controller do

  describe "#index" do
    let!(:all_products) { Product.all }
    before { get :index }

    it "assigns @products" do
      expect(assigns(:products)).to eq(all_products)
    end

    it "renders the :index view" do
      expect(response).to render_template(:index)
    end
  end

  describe "#new" do
    before { get :new }

    it "assigns @product" do
      expect(assigns(:product)).to be_instance_of(Product)
    end

    it "renders the :new view" do
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "on success" do

      let!(:products_count) { Product.count }

      before do
        wholesale_price = Random.new.rand(1.0..100.0).round(2)
        product_hash = {
            name: FFaker::Lorem.words(5).join(" "),
            description: FFaker::Lorem.sentence,
            category: FFaker::Lorem.words(3).join,
            sku: FFaker::Lorem.words(2).join,
            wholesale: wholesale_price,
            retail: wholesale_price * 4
          }

        post :create, product: product_hash
      end

      it "adds the new product to the database" do
        expect(Product.count).to eq(products_count + 1)
      end

      it "redirects to 'product_path'" do
        expect(response.status).to be(302)
        expect(response.location).to match(/\/products\/\d+/)
      end
    end

    context "failed validations" do
      before do
        # create blank product (fails validations)
        post :create, product: {
          name: nil,
          description: nil,
          category: nil,
          sku: nil,
          wholesale: nil,
          retail: nil
        }
      end

      it "displays a flash error message" do
        expect(flash[:error]).to be_present
      end

      it "redirects to 'new_product_path'" do
        expect(response.status).to be(302)
        expect(response).to redirect_to(new_product_path)
      end
    end
  end

  describe "#show" do
    let(:product) { FactoryGirl.create(:product) }

    before do
      get :show, id: product.id
    end

    it "assigns @product" do
      expect(assigns(:product)).to eq(product)
    end

    it "renders the :show view" do
      expect(response).to render_template(:show)
    end
  end

  describe "#edit" do
    let(:product) { FactoryGirl.create(:product) }
    before do
      get :edit, id: product.id
    end

    it "should assign @product" do
      expect(assigns(:product)).to eq(product)
    end

    it "should render the :edit view" do
      expect(response).to render_template(:edit)
    end
  end

  describe "#update" do
    let(:product) { FactoryGirl.create(:product) }

    context "success" do
      let(:new_name) { FFaker::Lorem.words(5).join(" ") }
      let(:new_description) { FFaker::Lorem.sentence }
      let(:new_category) { FFaker::Lorem.words(3).join }
      let(:new_sku) { FFaker::Lorem.words(2).join }
      let(:new_wholesale) { Random.new.rand(1.0..100.0).round(2) }
      let(:new_retail) { new_wholesale * 4 }

      before do
        put :update, id: product.id, product: {
          name: new_name,
          description: new_description,
          category: new_category,
          sku: new_sku,
          wholesale: new_wholesale,
          retail: new_retail
        }

        # reload product to get changes from :update
        product.reload
      end

      it "updates the product in the database" do
        expect(product.name).to eq(new_name)
        expect(product.description).to eq(new_description)
        expect(product.category).to eq(new_category)
        expect(product.sku).to eq(new_sku)
        expect(product.wholesale).to eq(new_wholesale.to_d) # compare decimal with decimal
        expect(product.retail).to eq(new_retail.to_d)
      end

      it "redirects to 'product_path'" do
        expect(response.status).to be(302)
        expect(response).to redirect_to(product_path(product))
      end
    end

    context "failed validations" do
      before do
        # update with blank product params (fails validations)
        put :update, id: product.id, product: {
          name: nil,
          description: nil,
          category: nil,
          sku: nil,
          wholesale: nil,
          retail: nil
        }
      end

      it "displays an error message" do
        expect(flash[:error]).to be_present
      end

      it "redirects to 'edit_product_path'" do
        expect(response).to redirect_to(edit_product_path(product))
      end
    end
  end

  describe "#destroy" do
    let!(:product) { FactoryGirl.create(:product) }
    let!(:products_count) { Product.count }

    before do
      delete :destroy, id: product.id
    end

    it "removes the product from the database" do
      expect(Product.count).to eq(products_count - 1)
    end

    it "redirects to 'root_path'" do
      expect(response.status).to be(302)
      expect(response).to redirect_to(root_path)
    end
  end
end
