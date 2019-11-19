class StripeService
  Stripe.api_key = ENV['STRIPE_API_KEY']

  def self.process(stripeToken, current_shopping_cart)
    new(stripeToken, current_shopping_cart).process
  end

  def initialize(stripeToken, current_shopping_cart)
    @token = stripeToken
    @current_shopping_cart = current_shopping_cart
  end

  def process
    Stripe::Charge.create({
      amount: @current_shopping_cart.subtotal_cents,
      currency: 'usd',
      source: @token
    })
  end
end
