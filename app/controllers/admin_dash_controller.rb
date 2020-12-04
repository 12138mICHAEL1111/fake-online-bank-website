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
      @user = User.new(user_params)
      if @user.save
        redirect_to('/admin_dash')
      else
        render('create_user')
      end

    end

    def create_account
        if current_user == nil || current_user.admin == false
            redirect_to '/'
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
end
