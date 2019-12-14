class StripeService
  Stripe.api_key = ENV['STRIPE_API_SECRET_KEY']

  def self.process(stripeToken, current_shopping_cart)
    new(stripeToken, current_shopping_cart).process
  end

  def initialize(stripeToken, current_shopping_cart)
    @token = stripeToken
    @current_shopping_cart = current_shopping_cart
  end

  def process
    charge = {errors:[]}

    begin
      charge = Stripe::Charge.create({
        amount: @current_shopping_cart.subtotal_cents,
        currency: 'u',
        source: @token
      })
    rescue Stripe::CardError => e

      puts "Status is: #{e.http_status}"
      puts "Type is: #{e.error.type}"
      puts "Charge ID is: #{e.error.charge}"
      # The following fields are optional
      puts "Code is: #{e.error.code}" if e.error.code
      puts "Decline code is: #{e.error.decline_code}" if e.error.decline_code
      puts "Param is: #{e.error.param}" if e.error.param
      puts "Message is: #{e.error.message}" if e.error.message
    rescue Stripe::RateLimitError => e
      charge[:errors].push("There was an error processing your payment. Please try again in a few minutes.")
      # Too many requests made to the API too quickly
    rescue Stripe::InvalidRequestError => e
      charge[:errors].push(e.message)
      # Invalid parameters were supplied to Stripe's API
    rescue Stripe::AuthenticationError => e
      charge[:errors].push(e.message)
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
    rescue Stripe::APIConnectionError => e
      charge[:errors].push(e.message)
      # Network communication with Stripe failed
    rescue Stripe::StripeError => e
      charge[:errors].push(e.message)
      # Display a very generic error to the user, and maybe send
      # yourself an email
    rescue => e
      # Something else happened, completely unrelated to Stripe
    end
    charge
  end
end
