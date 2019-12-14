class CustomersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    customer = Stripe::Customer.create(
      payment_method: params[:payment_method],
      email: params[:email],
      invoice_settings: {
        default_payment_method: params[:payment_method],
      }
    )

    u = User.find_by(email: current_user.email)
    u.update(stripe_customer_id: customer.id)

    subscription = Stripe::Subscription.create(
      customer: u.stripe_customer_id,
      items: [
        {
          plan: 'plan_GM7C4mHocKoU5t'
        }
      ],
      expand: ['latest_invoice.payment_intent']
    )
  end
end
