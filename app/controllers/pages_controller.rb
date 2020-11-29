class PagesController < ApplicationController
    def home
        if current_user
            if current_user.admin
                redirect_to '/admin_dash'
            else
                redirect_to '/dash'
            end
        end
    end
end
