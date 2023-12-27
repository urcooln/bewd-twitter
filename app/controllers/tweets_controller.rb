class TweetsController < ApplicationController
    def index
      @tweets = Tweet.order(created_at: :desc).all
      render 'tweets/index'
    end
  
    def create
      token = cookies.signed[:twitter_session_token]
      session = Session.find_by(token: token)
  
      # Assuming there's a user associated with the session
      user = session.user if session
  
      # Associate the tweet with the user
      @tweet = user.tweets.new(tweet_params)
  
      if @tweet.save
        render json: { tweet: tweet_response_attributes(@tweet) }, status: :created
      else
        render json: { errors: @tweet.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      token = cookies.signed[:twitter_session_token]
      session = Session.find_by(token: token)
  
      @tweet = Tweet.find(params[:id])
  
      if session
        @tweet.destroy
        render json: { success: true }, status: :ok
      else
        render json: { success: false }, status: :unauthorized
      end
    end

    def index_by_user
        user = User.find_by(username: params[:username])
    
        if user
          @tweets = user.tweets.order(created_at: :desc)
          render 'tweets/index'
        else
          render json: { error: "User with username #{params[:username]} not found" }, status: :not_found
        end
      end
  
    private
  
    def tweet_params
      params.require(:tweet).permit(:message)
    end
  
    def tweet_response_attributes(tweet)
      {
        username: tweet.user.username,
        message: tweet.message
      }
    end
  end
  