class AdminDashController < ApplicationController

    include AdminDashHelper

    def root
        p current_user
        if current_user == nil || current_user.admin == false
            redirect_to '/'
        else
            @users = User.where(:admin => false)
        end
    end

    def user
        if current_user == nil || current_user.admin == false
            redirect_to '/'
        else
            @user = User.find(params[:user_id])
            @accounts = @user.accounts
        end
    end

    def account
        if current_user == nil || current_user.admin == false
            redirect_to '/'
        else
            @account = Account.find(params[:account_id])
            @user = @account.user
            @accounts = @user.accounts
            @transactions = @account.transactions.order(completed_on: :desc)
        end
    end

    def create_user
        if current_user == nil || current_user.admin == false
            redirect_to '/'
        else
          @users = User.where(:admin => false)
          @user = User.new
        end
    end

    def create_user_post
      if current_user == nil || current_user.admin == false
          redirect_to '/'
      else
        p params
        @user = User.create({
          :email => params[:user][:email],
          :name => params[:user][:name],
          :password => params[:user][:password],
          :password_confirmation => params[:user][:password],
          :admin => false
        })
        if @user.save
          redirect_to('/admin_dash')
        else
          redirect_to('/admin_dash/create/user')
        end
      end
    end

    def create_account
        if current_user == nil || current_user.admin == false
            redirect_to '/'
        else
          @user = User.find(params[:user_id])
          @accounts = @user.accounts
          @account = Account.new
        end
    end

    def create_account_post
      if current_user == nil || current_user.admin == false
          redirect_to '/'
      else
          @account = Account.new({
            :user_id => params[:user_id],
            :name => params[:account][:name],
            :balance => 0,
            :currency => params[:account][:currency],
          })
          if @account.save
            redirect_to("/admin_dash/user/#{params[:user_id]}")
          else
            redirect_to("/admin_dash/create/account/#{params[:user_id]}")
          end
      end
    end

    def create_transaction
      if current_user == nil || current_user.admin == false
          redirect_to '/'
      else
        @account = Account.find(params[:account_id])
        @user = @account.user
        @accounts = @user.accounts
        @transactions = @account.transactions
        @transaction = Transaction.new
      end
    end

    def create_transaction_post
        if current_user == nil || current_user.admin == false
            redirect_to '/'
        else
          @transaction = Transaction.new({
            :account_id => params[:account_id],
            :amount => params[:transaction][:amount],
            :description => params[:transaction][:description],
            :completed_on => params[:transaction][:completed_on],
          })
          if @transaction.save
            @account = @transaction.account
            @account.balance = (@account.balance + @transaction.amount).round(2)
            @account.save

            redirect_to("/admin_dash/account/#{params[:account_id]}")
          else
            redirect_to("/admin_dash/create/transaction/#{params[:account_id]}")
          end
        end
    end

    def edit_transaction
      if current_user == nil || current_user.admin == false
          redirect_to '/'
      else
        @transaction = Transaction.find(params[:transaction_id])
        @account = @transaction.account
        @user = @account.user
        @accounts = @user.accounts
      end
    end

    def edit_transaction_post
      originalTransaction = Transaction.find(params[:transaction_id])
      @transaction = Transaction.find(params[:transaction_id])
      begin @transaction.update(tran_params)
        @account = @transaction.account
        @account.balance = (@account.balance-originalTransaction.amount + @transaction.amount).round(2)
        @account.save
        redirect_to("/admin_dash/account/#{@account.id}")
      rescue
        redirect_to("/admin_dash/edit/transaction/#{params[:transaction_id]}")
      end
    end

    def delete_transaction
      @transaction = Transaction.find(params[:transaction_id])
      @account = @transaction.account
      @account.balance = (@account.balance-@transaction.amount).round(2)
      @transaction.destroy
      @account.save
      redirect_to("/admin_dash/account/#{@account.id}")
    end

    def edit_account
      if current_user == nil || current_user.admin == false
          redirect_to '/'
      else
        @account = Account.find(params[:account_id])
        @user = @account.user
        @accounts = @user.accounts
      end
    end

    def edit_account_post
        @account =  Account.find(params[:account_id])
        @user = @account.user
        @account.update(account_params)
        @account.save
        redirect_to("/admin_dash/user/#{@user.id}")

    end

    def delete_account
      @account =  Account.find(params[:account_id])
      @user = @account.user
      @account.destroy
      redirect_to("/admin_dash/user/#{@user.id}")
    end

    def edit_user
      if current_user == nil || current_user.admin == false
          redirect_to '/'
      else
        @user = User.find(params[:user_id])
      end
    end

    def edit_user_post
      if current_user == nil || current_user.admin == false
          redirect_to '/'
      else
        @user =  User.find(params[:user_id])
        @user.update(user_params)
        @user.save
        redirect_to("/admin_dash")
      end
    end

    def delete_user
      @user =  User.find(params[:user_id])

      @user.destroy
      redirect_to("/admin_dash")
    end

    def generate_transaction
        if current_user == nil || current_user.admin == false
            redirect_to '/'
        else
            account = Account.find(params[:account_id].to_i)
            if generateTransactionArray(account.id)
              # generate the flash success
              redirect_to("/admin_dash/account/#{params[:account_id]}")
            else
              # generate the flash error
              redirect_to("/admin_dash")
              # the redirect was just used for debug
            end
        end
    end
    private
      def tran_params
        params.require(:transaction).permit(:amount,:description,:completed_on)
      end

      def account_params
        params.require(:account).permit(:name,:currency)
      end

      def user_params
        params.require(:user).permit(:email,:name)
      end


end
