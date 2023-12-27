class UsersController < ApplicationController
    def create
      @user = User.new(user_params)
  
      if @user.save
        render json: { user: user_response_attributes(@user) }, status: :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
  
    def user_response_attributes(user)
      {
        username: user.username,
        email: user.email
      }
    end
  end
  