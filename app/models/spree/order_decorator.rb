Spree::Order.class_eval do
  # override the add_variant functionality so that we can adjust the price based on possible volume adjustment
  def add_variant(variant, quantity=1)
    current_item = find_line_item_by_variant(variant)
    price = variant.volume_price(quantity) # Added
    if current_item
      current_item.increment_quantity unless quantity > 1
      current_item.quantity = (current_item.quantity + quantity) if quantity > 1
      current_item.price = price # Added
      current_item.save
    else
      current_item = line_items.create(:quantity => quantity)
      current_item.variant = variant
      current_item.price = price
      current_item.save
    end

  end
end
