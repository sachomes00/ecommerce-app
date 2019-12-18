class OrderService
  def self.process(order_params, current_shopping_cart)
    new(order_params, current_shopping_cart).process
  end

  def initialize(params, current_shopping_cart)
    @order_params = params
    @order = Order.new(name: @order_params[:name], email: @order_params[:email], charge_id: @order_params[:charge_id])
    @current_shopping_cart = current_shopping_cart
  end

  def process
    add_total_to_order
    add_line_items_to_order
  end

  def add_line_items_to_order
    @current_shopping_cart.line_items.each do |line_item|
      @order.line_items << line_item
      if line_item.product.is_subscription
        customer = Stripe::Customer.create(
          payment_method: @order_params[:payment_method],
          email: @order.email,
          invoice_settings: {
            default_payment_method: @order_params[:payment_method],
          }
        )
        subscription = Stripe::Subscription.create(
        customer: customer.id,
        items: [
          {
            plan: product.stripe_plan
          }
        ],
        expand: ['latest_invoice.payment_intent']
      )
      end
      line_item.shopping_cart_id = nil
    end

    @order
  end

  def add_total_to_order
    @order.total = @current_shopping_cart.subtotal
  end
end
