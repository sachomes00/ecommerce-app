class OrdersController < ApplicationController
  Stripe.api_key = ENV['STRIPE_API_SECRET_KEY']

  def show
    @order = Order.find(params[:id])
  end

  def new
    if @current_shopping_cart.line_items.any?
      @order = Order.new
      @intent = Stripe::PaymentIntent.create({
        amount: @current_shopping_cart.subtotal_cents,
        currency: 'usd',
      })
    else
      redirect_to shopping_cart_path(@current_shopping_cart)
    end
  end

  def create
    # charge = StripeService.process(params[:stripeToken], @current_shopping_cart)
    @order = OrderService.process(order_params.merge(charge_id: params[:paymentIntentId]), @current_shopping_cart)

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
