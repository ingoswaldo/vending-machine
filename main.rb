# frozen_string_literal: true

require_relative 'app/helpers/classes/user'
require_relative 'app/helpers/classes/drink'
require_relative 'app/helpers/modules/message'
require_relative 'app/helpers/modules/loop'

# Execute the vending machine program
class Main
  def self.run
    Message.hello
    user = User.new
    fill_user_name user
    sell_or_quit(user)
  end

  private

  def self.add_bills(user)
    Loop.infinite do |continue|
      input_bill = Message.ask('Please, add your bill').to_i
      if user.valid_bill? input_bill
        user.add_bill input_bill
        user.mount_message
        continue = false
      end
      continue
    end
  end

  def self.add_coins(user)
    Loop.infinite do |continue|
      input_coin = Message.ask('Please, add your coin').to_i
      if user.valid_coin?(input_coin)
        user.add_coin input_coin
        user.mount_message
        continue = false
      end
      continue
    end
  end

  def self.add_user_money(user)
    Loop.infinite do |continue|
      options_money_type = { '1': 'Add Bills', '2': 'Add Coins', '3': 'Quit' }
      input_money_type = Message.ask "#{user.full_name.capitalize}, Add money to your wallet", options_money_type
      case_input_money_type(input_money_type, user)
      continue = false if input_money_type == '3'
      continue
    end
    nil
  end

  def self.case_input_money_type(input_money_type, user)
    case input_money_type
    when '1'
      add_bills(user)
    when '2'
      add_coins(user)
    end
  end

  def self.choose_drink_and_pay(drinks, input, user)
    drink = drinks[input.to_i - 1]
    puts "You don't have money to buy #{drink.name}" if user.mount < drink.cost
    puts "#{drink.name} is sold out" unless drink.stock?
    user.pay drink if drink.stock? && user.mount >= drink.cost
  end

  def self.fill_user_name(user)
    user.full_name = Message.ask("What's your full name?")
  end

  def self.get_drink_options(drinks)
    options = {}
    key = 1
    drinks.each do |drink|
      options.merge!("#{key}": drink.to_s)
      key += 1
    end
    options.merge!('q': 'Quit')
    options
  end

  def self.initialize_drinks
    [
      Drink.new('Coke', 2500, 5),
      Drink.new('Water', 2000, 4),
      Drink.new('Oatmeal', 1500, 3),
      Drink.new('Tea', 100, 2),
    ]
  end

  def self.print_machine_mount(mount)
    Message.print_30_lines
    puts "The machine has $#{mount}"
    Message.print_30_lines
  end

  def self.print_drinks(drinks, with_machine_mount: false)
    machine_mount = 0
    puts 'List of drinks in the machine'
    Message.print_30_lines
    drinks.each do |drink|
      print "#{drink.to_s} \n"
      machine_mount += drink.mount_sold if with_machine_mount
    end
    Message.print_30_lines
    print_machine_mount machine_mount if with_machine_mount
  end

  def self.quit?(drinks)
    options = { '1': 'Yes', '2': 'No' }
    input = Message.ask 'Do you want continue?', options
    if input == '2'
      print_drinks drinks, with_machine_mount: true
      Message.stop
      return true
    end
    false
  end

  def self.sell_or_quit(user)
    drinks = initialize_drinks
    Loop.infinite do |continue|
      print_drinks drinks
      add_user_money user
      sell_drinks drinks, user
      continue = false if quit?(drinks)
      continue
    end
  end

  def self.sell_drinks(drinks, user)
    Loop.infinite do |continue|
      Message.print_30_lines
      options = get_drink_options(drinks)
      input = Message.ask 'What do you want to drink?', options
      continue = false if input == 'q'
      choose_drink_and_pay(drinks, input, user) if continue && options.key?(:"#{input}")
      continue
    end
  end
end

Main.run
