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
        redirect_to '/'
    end

    def sign_in_post
        @user = User.find_by_email(params[:email])

        if @user == nil
            flash[:alert] = "Error: Something went wrong"
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
                flash[:alert] = "Error: Something went wrong"
                redirect_to '/sign_in'
            end
        end
    end

    def sign_up_post
        p params
        p "heeej"
        @user = User.create({
            :email => params[:email],
            :name => params[:name],
            :password => params[:password],
            :password_confirmation => params[:password_confirmation],
            :admin => params[:admin] || false
        })
        p @user
        p "heeej"
        if @user.save
          sign_in @user
        if @user.admin
            redirect_to '/admin_dash'
        else
            redirect_to '/dash'
        end
      else
        if (params[:name]=~/(^[a-zA-Z\.\s\']+$)|^$/) == nil
          flash[:alert] = "Error: name should not contain any number or special character"
        end
        if (params[:email]=~/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i) == nil
          flash[:alert] = "Error: wrong format of email"
        end
        if(params[:password]!=params[:password_confirmation])
          flash[:alert] = "Error: please input same password"
        end
        redirect_to '/sign_up'
      end
    end
end
