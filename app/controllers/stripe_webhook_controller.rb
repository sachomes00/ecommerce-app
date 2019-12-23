class StripeWebhookController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    head :ok
  end
end
