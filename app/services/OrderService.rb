class OrderService
  def self.process(order_params, current_shopping_cart)
    new(order_params, current_shopping_cart).process
  end

  def initialize(params, current_shopping_cart)
    @order = Order.new(params)
    @current_shopping_cart = current_shopping_cart
  end

  def process
    add_total_to_order
    add_line_items_to_order
  end

  def add_line_items_to_order
    @current_shopping_cart.line_items.each do |line_item|
      @order.line_items << line_item
      line_item.shopping_cart_id = nil
    end

    @order
  end

  def add_total_to_order
    @order.total = @current_shopping_cart.subtotal
  end
end
