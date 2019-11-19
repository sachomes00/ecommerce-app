class LineItemsController < ApplicationController
  def create
    product = Product.find(params[:product_id])
    current_shopping_cart = @current_shopping_cart

    if current_shopping_cart.products.include?(product)
      @line_item = current_shopping_cart.line_items.find_by(product_id: product)
      @line_item.quantity += 1
    else
      @line_item = LineItem.new
      @line_item.shopping_cart = current_shopping_cart
      @line_item.product = product
    end

    @line_item.save
    redirect_to shopping_cart_path(current_shopping_cart)
  end

  def update
    @line_item = LineItem.find(params[:id])
    params[:add] ? @line_item.quantity += 1 : @line_item.quantity -= 1
    @line_item.save
    redirect_to shopping_cart_path(@current_shopping_cart)
  end

  def destroy
    line_item = LineItem.find(params[:id])
    line_item.destroy
    redirect_to shopping_cart_path(@current_shopping_cart)
  end
end
