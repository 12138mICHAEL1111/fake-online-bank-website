class AuthController < ApplicationController
    def sign_in_get
        if current_user
            if current_user.admin
                redirect_to '/admin_dash'
            else
                redirect_to '/dash'
            end
        end
    end

    def sign_out_post
        sign_out
        redirect_to '/'
    end

    def sign_in_post
        @user = User.find_by_email(params[:email])

        if @user == nil
            flash[:alert] = "Error: incorrect email or password"
            redirect_to '/sign_in'
        else
            if @user.valid_password?(params[:password])
                sign_in @user
                if @user.admin
                    redirect_to '/admin_dash'
                else
                    redirect_to '/dash'
                end
            else
                  flash[:alert] = "Error: incorrect email or password"
                redirect_to '/sign_in'
            end
        end
    end
end
