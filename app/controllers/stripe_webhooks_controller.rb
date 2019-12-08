class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
          payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      render nothing: true, status: :bad_request
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render nothing: true, status: :bad_request
    end
    case event['type']
    when 'payment_intent.succeeded'
      intent = event['data']['object']
      puts "Succeeded:", intent['id']
      # Fulfill the customer's purchase
    when 'payment_intent.payment_failed'
      intent = event['data']['object']
      error_message = intent['last_payment_error'] && intent['last_payment_error']['message']
      puts "Failed:", intent['id'], error_message
      # Notify the customer that payment failed
    end

    status 200
  end
end
