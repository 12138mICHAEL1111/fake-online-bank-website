module ApplicationHelper

  def combineCurrencyAmount(currency, amount, type)
    # display 100 instead of 100.0
    if amount % 10 == 0
      amount = amount.round
    end

    # display "-$300" and "+$300"
    if amount < 0
      "-#{currency}#{(amount).abs}"
    else
      if type == "Transaction Amount"
        "+#{currency}#{amount}"
      else
        "#{currency}#{amount}"
      end
    end
  end

  def current_theme
    if Theme.all.count == 0
      Theme.create({name: "Banking 101", font: "Arial", buttons_color: "#007BFF"})
    else
      Theme.find(1)
    end
  end
end
