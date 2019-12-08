class StripeService
  Stripe.api_key = ENV['STRIPE_API_SECRET_KEY']

  def self.process(current_shopping_cart)
    new(current_shopping_cart).process
  end

  def initialize(current_shopping_cart)
    @current_shopping_cart = current_shopping_cart
  end

  def process
    Stripe::PaymentIntent.create({
      amount: @current_shopping_cart.subtotal_cents,
      currency: 'usd'
    })
  end
end
