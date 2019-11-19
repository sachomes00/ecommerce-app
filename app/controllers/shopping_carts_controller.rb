class ShoppingCartsController < ApplicationController
  def show
    @shopping_cart = @current_shopping_cart
  end

  def destroy
    @shopping_cart = @current_shopping_cart
    @shopping_cart.destroy
    session[:shopping_cart_id] = nil
    redirect_to root_path
  end
end
