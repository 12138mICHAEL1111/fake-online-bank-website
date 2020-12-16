require 'test_helper'

class DashControllerTest < ActionDispatch::IntegrationTest

  include ApplicationHelper

  def create_user
    user = User.new(email:"user@test.com",name: "testUser",password:'123456',password_confirmation:'123456',admin:false)
    user.save
    get"/sign_in"
    post"/sign_in_post",params:{email: 'user@test.com', password: '123456'}
  end

  def create_account(balance)
    create_user
    user = User.find_by_email("user@test.com")
    account = Account.new(name: "testAccount", balance: balance, currency: "$", user_id: user.id)
    account.save
  end

  test 'should get dash with logged user' do
    create_user
    get '/dash'
    assert_response :success
  end

  test 'should redirect to root without logged user' do
    get '/dash'
    assert_redirected_to '/'
  end

  test 'should get transactions with logged user' do
    create_account(0)
    account = Account.find_by_name("testAccount")
    get "/dash/account/#{account.id}"
    assert_response :success
  end

  test 'should redirect to root without logged user on transactions' do
    user = User.new(email:"user@test.com",name: "testUser",password:'123456',password_confirmation:'123456',admin:false)
    user.save
    account = Account.new(name: "testAccount", balance: 0, currency: "$", user_id: user.id)
    account.save

    get "/dash/account/#{account.id}"
    assert_redirected_to '/'
  end

  # helpers tests
  test 'should combine currency and positive amount in the correct way for account' do
    create_account(0)
    account = Account.find_by_name("testAccount")
    balance_sign = (account.balance < 0) ? "-" : ""
    assert_equal(combineCurrencyAmount(account.currency, account.balance, "Account Balance"),
                "#{balance_sign}#{account.currency}#{account.balance.round}")
  end

  test 'should combine currency and negative amount in the correct way for account' do
    create_account(-100)
    account = Account.find_by_name("testAccount")
    balance_sign = (account.balance < 0) ? "-" : ""
    assert_equal(combineCurrencyAmount(account.currency, account.balance, "Account Balance"),
                "#{balance_sign}#{account.currency}#{account.balance.round.abs}")
  end

  test 'should combine currency and negative amount in the correct way for transaction' do
    create_account(-100)
    account = Account.find_by_name("testAccount")
    transaction = Transaction.new(account_id: account.id, amount: -100, completed_on: "03-02-2020")
    transaction.save
    sign = transaction.amount < 0 ? "-" : "+"
    assert_equal(combineCurrencyAmount(transaction.account.currency, transaction.amount, "Transaction Amount"),
                  "#{sign}#{account.currency}#{transaction.amount.round.abs}")
  end

  test 'should combine currency and positive amount in the correct way for transaction' do
    create_account(100)
    account = Account.find_by_name("testAccount")
    transaction = Transaction.new(account_id: account.id, amount: 100, completed_on: "03-02-2020")
    transaction.save
    sign = transaction.amount < 0 ? "-" : "+"
    assert_equal(combineCurrencyAmount(transaction.account.currency, transaction.amount, "Transaction Amount"),
                  "#{sign}#{account.currency}#{transaction.amount.round.abs}")
  end



end
