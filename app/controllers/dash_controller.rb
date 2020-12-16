require 'date'

class DashController < ApplicationController
    def root
        if current_user == nil || current_user.admin == true
            redirect_to '/'
        else
            @accounts = current_user.accounts
        end

    end

    def account
        if current_user == nil || current_user.admin == true
            redirect_to '/'
        else
            @account = Account.find(params[:account_id])
            if @account.user_id != current_user.id
                redirect_to '/'
            else
                @transactions = @account.transactions.order(completed_on: :desc)
            end

        end
    end

    def create_transaction
      if current_user == nil || current_user.admin == true
          redirect_to '/'
      else
        @account = Account.find(params[:account_id])
        @user = @account.user
        @accounts = @user.accounts
        @transactions = @account.transactions.order(completed_on: :desc)
        @transaction = Transaction.new
      end
    end

    def create_transaction_post
        if current_user == nil || current_user.admin == true
            redirect_to '/'
        else if params[:transaction][:amount].to_f < 0
            flash[:alert] = "Error: You can't send a negative amount"
            redirect_to "/dash/create/transaction/#{params[:account_id]}"
        else
          @transaction = Transaction.new({
            :account_id => params[:account_id],
            :amount => -(params[:transaction][:amount].to_f),
            :description => params[:transaction][:description],
            :completed_on => DateTime.now.strftime('%d/%m/%Y'),
          })
          if @transaction.account.balance < params[:transaction][:amount].to_f
            flash[:alert] = "Error: You don't have enough money in this account"
            redirect_to "/dash/create/transaction/#{params[:account_id]}"
          else
          begin @transaction.save
            @account = @transaction.account
            @account.balance = (@account.balance + @transaction.amount).round(2)
              redirect_to("/dash/account/#{params[:account_id]}")
            @account.save

          rescue
            flash[:alert] = "Error: Something went wrong"
            redirect_to("/dash/create/transaction/#{params[:account_id]}")
          end
          end
        end
        end
    end
end
