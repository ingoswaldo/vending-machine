# frozen_string_literal: true

# Drink class
class Drink
  attr_accessor :name, :cost, :quantity
  attr_reader :mount_sold

  def initialize(name, cost, quantity)
    @name = name
    @cost = cost
    @quantity = quantity
    @mount_sold = 0
  end

  def sell(money, quantity)
    return 0 unless stock?

    update_stock quantity
    update_mount_sold quantity
    get_change money, quantity
  end

  def stock?
    quantity >= 1
  end

  def to_s
    "Drink Name: #{name}, Cost: #{cost}, Quantity: #{quantity}"
  end

  private

  def get_change(money, quantity)
    money - (cost * quantity)
  end

  def update_mount_sold(quantity_sold)
    @mount_sold += (quantity_sold * cost)
  end

  def update_stock(quantity_sold)
    @quantity -= quantity_sold if quantity_sold <= quantity
  end
end
