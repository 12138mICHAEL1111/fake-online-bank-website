class AdminDashController < ApplicationController
    def root
        p current_user
        if current_user == nil || current_user.admin == false
            p "hej"
            redirect_to '/'
        else @users = User.where(:admin => false)
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
        end
    end

    def create_user
        if current_user == nil || current_user.admin == false
            redirect_to '/'
        else
          @user = User.new
        end
    end

    def create_user_post
      if current_user == nil || current_user.admin == false
          redirect_to '/'
      else
        @user = User.new(user_params)
      if @user.save
        redirect_to('/admin_dash')
      else
        render('create_user')
   end
    end
    end

    def create_account
        if current_user == nil || current_user.admin == false
            redirect_to '/'
        else
          @user = User.find(params[:user_id])
          @account = Account.new
        end
    end

    def create_account_post
      if current_user == nil || current_user.admin == false
          redirect_to '/'
      else
          @account = Account.new(account_params)
          @user = User.find(params[:user_id])
          if @account.save
            redirect_to("/admin_dash/user/#{@user.id}")
          else
            render('create_account')
          end
      end
    end

    def create_transaction
        if current_user == nil || current_user.admin == false
            redirect_to '/'
        end
    end

    def user_params
      params.require(:user).permit(:email, :name, :password)
    end

    def account_params
      params.require(:account).permit(:name, :currency, :user_id)
    end
end
