# frozen_string_literal: true

# Wallet module
module Wallet
  BILLS = [1000, 2000, 5000].freeze
  COINS = [100, 200, 500].freeze

  attr_reader :bills, :coins

  def add_bill(bill)
    @bills.push bill
  end

  def add_coin(coin)
    @coins.push coin
  end

  def bills?
    !@bills.empty?
  end

  def choose_bills_from_total(total)
    choose_money = @bills[total] || (@bills.select { |bill| bill > total }).min || @bills.max
    remove_bill(@bills.index(choose_money))
    choose_money
  end

  def choose_coins_from_total(total)
    choose_money = @coins[total] || (@coins.select { |coin| coin > total }).min || @coins.max
    remove_coin(@coins.index(choose_money))
    choose_money
  end

  def coins?
    !@coins.empty?
  end

  def get_bill_from_change(change)
    bill = BILLS.select { |bill| bill <= change }.first
    add_bill bill
    bill
  end

  def get_coin_from_change(change)
    coin = COINS.select { |coin| coin <= change }.first
    add_coin coin
    coin
  end

  def mount
    @bills.sum + @coins.sum
  end

  def remove_bill(index)
    @bills.delete_at index
  end

  def remove_coin(index)
    @coins.delete_at index
  end

  def valid_bill?(bill)
    BILLS.include? bill
  end

  def valid_coin?(coin)
    COINS.include? coin
  end
end
