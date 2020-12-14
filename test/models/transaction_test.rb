require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  test "transaction with all parameters correctly validated is valid" do
    account = accounts(:testAccount)
    transaction = Transaction.new(amount:12.34, description:'tesco',completed_on:'2020-12-10', account_id:account.id)
    assert transaction.save
  end

  test "transaction with no amount is not valid" do
    account = accounts(:testAccount)
    transaction = Transaction.new(description:'tesco',completed_on:'2020-12-10', account_id:account.id)
    assert_not transaction.save
  end

  test "transaction with no description is not valid" do
    account = accounts(:testAccount)
    transaction = Transaction.new(amount:12.34,completed_on:'2020-12-10', account_id:account.id)
    assert_not transaction.save
  end

  test "transaction with no time is not valid" do
    account = accounts(:testAccount)
    transaction = Transaction.new(description:'tesco',amount:12.34, account_id:account.id)
    assert_not transaction.save
  end

  test "transaction with amount containing letters is not valid" do
    account = accounts(:testAccount)
    transaction = Transaction.new(amount:'12.34aa', description:'tesco',completed_on:'2020-12-10', account_id:account.id)
    assert_not transaction.save
  end
end
