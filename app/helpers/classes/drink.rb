# frozen_string_literal: true

# Drink class
class Drink
  attr_accessor :name, :cost, :quantity

  def initialize(name, cost, quantity)
    @name = name
    @cost = cost
    @quantity = quantity
  end

  def sell(money, quantity)
    change = 0
    if stock?
      update_stock quantity
      change = get_change money, quantity
    end
    change
  end

  def stock?
    @quantity >= 1
  end

  def to_s
    "Drink Name: #{@name}, Cost: #{@cost}, Quantity: #{@quantity}"
  end

  private

  def get_change(money, quantity)
    money - (@cost * quantity)
  end

  def update_stock(quantity_sold)
    @quantity -= quantity_sold if quantity_sold <= @quantity
    nil
  end
end
