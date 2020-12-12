require "faker"

module AdminDashHelper

  def generateTransactionArray(account_id)
    types = ["Restaurant", "Appliances", "Bills", "Bills", "Friend"]
    types.each do |t|
      transaction = Transaction.new(getTransactionHash(account_id, t))
      if !saveTransactionAndUpdateBalance(transaction)
        return false
      end
    end
    return true
  end

  # get a transaction_hash for a specific type of random generated data
  def getTransactionHash(account_id, type)
    case type
    when "Restaurant"
      {
        account_id: account_id,
        description: Faker::Restaurant.name,
        amount: Faker::Number.normal(mean: -30, standard_deviation: 5).to_d.round(2),
        completed_on: Faker::Date.between(from: "2020-01-01", to: "2020-12-30")
      }
    when "Appliances"
      {
        account_id: account_id,
        description: Faker::Appliance.brand,
        amount: Faker::Number.normal(mean: -200, standard_deviation: 20).to_d.round(2),
        completed_on: Faker::Date.between(from: "2020-01-01", to: "2020-12-30")
      }
    when "Bills"
      {
        account_id: account_id,
        description: Faker::Company.name,
        amount: Faker::Number.normal(mean: -20, standard_deviation: 2.5).to_d.round(2),
        completed_on: Faker::Date.between(from: "2020-01-01", to: "2020-12-30")
      }
    when "Friend"
      {
        account_id: account_id,
        description: Faker::Name.name,
        amount: Faker::Number.normal(mean: 70, standard_deviation: 25).to_d.round(2),
        completed_on: Faker::Date.between(from: "2020-01-01", to: "2020-12-30")
      }
    end
  end

  def saveTransactionAndUpdateBalance(new_transaction)
    if new_transaction.save
      account = new_transaction.account
      account.balance = (account.balance + new_transaction.amount).round(2)
      if account.save
        return true
      else
        return false
      end
    end
    return false
  end









end
