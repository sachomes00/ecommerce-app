class StripeWebhooksController < ApplicationController
  def create
    if params["type"] && params["type"] == "payment_intent.succeeded"
    end
  end
end
