class CardsController < ApplicationController
  skip_before_action :verify_authenticity_token

  Stripe.api_key = ENV['STRIPE_API_SECRET_KEY']

  def create
    if (payment_method = params[:paymentMethod])
      customer = Stripe::Customer.create(payment_method: payment_method)
    end
  end
end
