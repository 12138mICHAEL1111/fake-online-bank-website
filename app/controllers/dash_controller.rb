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
end
