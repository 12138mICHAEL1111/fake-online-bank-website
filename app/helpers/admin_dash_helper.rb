module AdminDashHelper
  # used for transaction's amount
  def combineCurrencyAmount(amount, currency)
    # display 100 instead of 100.0
    if amount % 10 == 0
      amount = amount.round
    end

    # display "-$300" and "+$300"
    if amount < 0
      "-#{currency}#{(amount).abs}"
    else
      "+#{currency}#{amount}"
    end
  end

  # used for account's balance
  def combineCurrencyBalance(balance, currency)
    if balance % 10 == 0
      balance = balance.round
    end
    "#{currency}#{balance}"
  end
end
