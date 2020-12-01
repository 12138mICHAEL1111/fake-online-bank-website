module DashHelper
  def combineCurrencyAmount(amount, currency)
    if amount % 10 == 0
      amount = amount.round
    end

    if amount < 0
      "-#{currency}#{amount}"
    else
      "+#{currency}#{amount}"
    end
  end
end
