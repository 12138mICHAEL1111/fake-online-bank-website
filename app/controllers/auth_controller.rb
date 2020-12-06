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

    def sign_up_get
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
        redirect_to '/hej'
    end

    def sign_in_post
        @user = User.find_by_email(params[:email])

        if @user == nil
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
                redirect_to '/sign_in'
            end
        end
    end

    def sign_up_post
        p params
        @new_user = User.new
        p @new_user
        @user = User.create({
            :email => params[:email],
            :name => params[:name],
            :password => params[:password],
            :password_confirmation => params[:password_confirmation],
            :admin => params[:admin] || false
        })
        @user.save
        sign_in @user
        if @user.admin
            redirect_to '/admin_dash'
        else
            redirect_to '/dash'
        end
    end
end
