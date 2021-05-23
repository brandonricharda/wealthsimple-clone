class ApplicationController < ActionController::Base
    def after_sign_in_path_for(resource)
        if resource.class == User
            user_url(resource.id)
        end
    end
end