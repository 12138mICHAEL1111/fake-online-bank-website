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
          flash[:alert] = "Error: Something went wrong"
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
            flash[:alert] = "Error: Something went wrong"
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
        @transactions = @account.transactions.order(completed_on: :desc)
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
          begin @transaction.save
            @account = @transaction.account
            @account.balance = (@account.balance + @transaction.amount).round(2)
              redirect_to("/admin_dash/create/transaction/#{params[:account_id]}")

          rescue
            flash[:alert] = "Error: Something went wrong"
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
      if current_user == nil || current_user.admin == false
          redirect_to '/'
      else
        originalTransaction = Transaction.find(params[:transaction_id])
        @transaction = Transaction.find(params[:transaction_id])
        @transaction.update(tran_params)
        @account = @transaction.account
        @account.balance = (@account.balance-originalTransaction.amount + @transaction.amount).round(2)
          if @transaction.save
            @account.save
            redirect_to("/admin_dash/account/#{@account.id}")
          else
            flash[:alert] = "Error: Something went wrong"
            redirect_to("/admin_dash/edit/transaction/#{params[:transaction_id]}")
          end
      end
    end

    def delete_transaction
      if current_user == nil || current_user.admin == false
          redirect_to '/'
      else
        @transaction = Transaction.find(params[:transaction_id])
        @account = @transaction.account
        @account.balance = (@account.balance-@transaction.amount).round(2)
        @transaction.destroy
        @account.save
        redirect_to("/admin_dash/account/#{@account.id}")
      end
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
      if current_user == nil || current_user.admin == false
          redirect_to '/'
      else
        @account =  Account.find(params[:account_id])
        @user = @account.user
        @account.update(account_params)
        if @account.save
          redirect_to("/admin_dash/user/#{@user.id}")
        else
          flash[:alert] = "Error: Something went wrong"
          redirect_to("/admin_dash/edit/account/#{@account.id}")
        end
      end
    end

    def delete_account
      if current_user == nil || current_user.admin == false
          redirect_to '/'
      else
        @account =  Account.find(params[:account_id])
        @user = @account.user
        @account.destroy
        redirect_to("/admin_dash/user/#{@user.id}")
      end
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
        if  @user.save
          redirect_to("/admin_dash")
        else
          flash[:alert] = "Error: Something went wrong"
          redirect_to("/admin_dash/edit/user/#{@user.id}")
        end
      end
    end

    def delete_user
      if current_user == nil || current_user.admin == false
          redirect_to '/'
      else
        @user =  User.find(params[:user_id])

        @user.destroy
        redirect_to("/admin_dash")
      end
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

    def look_and_feel
      if current_user == nil || current_user.admin == false
        redirect_to '/'
      else
        @theme = Theme.find(1)
      end
    end

    def look_and_feel_post
      if current_user == nil || current_user.admin == false
        redirect_to '/'
      else
        begin
          @theme = Theme.find(1)
          @theme.name = params[:theme][:name]
          @theme.font = params[:theme][:font]
          @theme.buttons_color = params[:theme][:buttons_color]
          @theme.save
        rescue
          flash[:alert] = "Error: Something went wrong"
        end
        redirect_to("/admin_dash/look_and_feel")
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
