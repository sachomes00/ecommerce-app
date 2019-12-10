class StripeService
  Stripe.api_key = ENV['STRIPE_API_SECRET_KEY']

  def self.process(params, current_shopping_cart)
    new(params, current_shopping_cart).process
  end

  def initialize(params, current_shopping_cart)
    @token = params[:stripeToken]
    @customer_email = params[:order][:email]
    @customer_name = params[:order][:name]
    @current_shopping_cart = current_shopping_cart
  end

  def process
    if current_user.stripe_customer_id.nil?
      customer = Stripe::Customer.create({
        source: @token,
        email: @customer_email,
      })

      User.update(stripe_customer_id: customer.id)

      Stripe::Charge.create({
        amount: @current_shopping_cart.subtotal_cents,
        currency: 'usd',
        customer: customer.id,
      })
    else
      Stripe::Charge.create({
        amount: @current_shopping_cart.subtotal_cents,
        currency: 'usd',
        customer: user.stripe_customer_id,
      })
    end

  end
end
