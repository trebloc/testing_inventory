class ProductsController < ApplicationController
  def index
    @products = Product.all
    render :index
  end

  def new
  	@product = Product.new
  end

  def create
  	product_params = params.require(:product).permit(:name, :description, :category, :sku, :wholesale, :retail)
  	@product = Product.new(product_params)
  	if @product.save
			flash[:notice] = "Successfully added product"
  		redirect_to product_path(@product)
  	    else
        flash[:error] = "Product addition failed!"
        redirect_to new_product_path
      end
   end

  def show
    @product = Product.find_by_id(params[:id])
  end

  def update
  	product_params = params.require(:product).permit(:name, :description, :category, :sku, :wholesale, :retail)
  	@product = Product.find_by_id(params[:id])
  	if @product.update_attributes(product_params)
  		flash[:notice] = "Successfully updated product."
      redirect_to product_path(@product)
 			else
	      flash[:error] = @product.errors.full_messages.join(", ")
	      redirect_to edit_product_path(@product)
    	end
    end	

  def edit
    @product = Product.find_by_id(params[:id])
    render :edit
  end

  def destroy
  	@product = Product.find_by_id(params[:id])
  	@product.destroy
    flash[:notice] = "Successfully deleted product."  	
  	redirect_to root_path
	end
end
