# frozen_string_literal: true

# frozen_string_literal: true]

$LOAD_PATH << '.'
require 'app/helpers/modules/wallet'
require 'app/helpers/modules/loop'

# User class
class User
  include Wallet

  attr_accessor :full_name

  def initialize
    @full_name = ''
    @bills = []
    @coins = []
  end

  def choose_money(total)
    choose_money = 0
    choose_money = choose_coins_from_total(total) if (total < 1000 && coins?) || @coins.sum >= total
    choose_money = choose_bills_from_total(total) if bills?
    choose_money
  end

  def mount_message
    puts "#{@full_name.capitalize}, you have $#{mount} in your wallet"
  end

  def pay(drink)
    chosen_money = []
    total = drink.cost
    until total <= 0
      choose_money = choose_money(total)
      chosen_money.push(choose_money) if choose_money != 0
      total = drink.cost - chosen_money.sum
    end
    change = drink.sell(chosen_money.sum, 1)
    save_change change if change.positive?
    mount_message
  end

  def save_change(change)
    if valid_bill? change
      add_bill change
      return
    end
    if valid_coin? change
      add_coin change
      return
    end
    save_bills_coins_from_change(change)
  end

  private

  def save_bills_coins_from_change(change)
    Loop.infinite do |continue|
      change -= if change < 1000
                  get_coin_from_change(change)
                else
                  get_bill_from_change(change)
                end
      continue = false if change.zero?
      continue
    end
  end
end
