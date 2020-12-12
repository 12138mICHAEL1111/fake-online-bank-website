module ApplicationHelper

  def combineCurrencyAmount(currency, amount)
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
end
