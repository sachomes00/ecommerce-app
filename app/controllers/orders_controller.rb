class OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
  end

  def new
    if @current_shopping_cart.line_items.any?
      @order = Order.new
    else
      redirect_to shopping_cart_path(@current_shopping_cart)
    end
  end

  def create
    charge = StripeService.process(params, @current_shopping_cart)
    @order = OrderService.process(order_params.merge(charge_id: charge.id), @current_shopping_cart)

    if @order.save
      ShoppingCart.destroy(session[:shopping_cart_id])
      session[:shopping_cart_id] = nil
      redirect_to order_path(@order)
    else
      redirect_to shopping_cart_path(@current_shopping_cart)
    end
  end

  def order_params
    params.require(:order).permit(:name, :email)
  end
end
