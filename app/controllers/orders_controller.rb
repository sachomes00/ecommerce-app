class OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
  end

  def new
    if @current_shopping_cart.line_items.any?
      @order = Order.new
      @payment_intent = StripeService.process(@current_shopping_cart)
    else
      redirect_to shopping_cart_path(@current_shopping_cart)
    end
  end

  def create
    @order = OrderService.process(order_params.merge(payment_intent_id: params[:paymentIntentId]), @current_shopping_cart)

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
