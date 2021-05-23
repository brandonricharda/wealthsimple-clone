class RegistrationsController < Devise::RegistrationsController
    def resource_name
        :user
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        respond_to do |format|
            if @user.save
                format.html { redirect_to @user }
            else
                format.html { redirect_to request.referrer }
            end
        end
    end

    def update
        super
    end

    private
    
    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :risk_tolerance)
    end
end 