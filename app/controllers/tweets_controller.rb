class TweetsController < ApplicationController
  before_action :set_tweet, only: [:like, :unlike]

  def index
    @users = User.order(followers_count: :desc).limit(10)# 基於測試規格，必須講定變數名稱，請用此變數中存放關注人數 Top 10 的使用者資料
    @tweets = Tweet.order(created_at: :desc)
    @tweet = Tweet.new
  end

  def create
    @tweet = current_user.tweets.build(tweet_params)
    if @tweet.save
      flash[:notice] = "Created successfully!"
      redirect_to tweets_path
    else
      flash[:alert] = "False to create"
      redirect_to tweets_path
    end
  end

  def like
    current_user.likes.create!(tweet: @tweet)
    redirect_to tweets_path
  end

  def unlike
    current_user.likes.where(tweet: @tweet).destroy_all
    redirect_to tweets_path
  end

  private

  def tweet_params
    params.require(:tweet).permit(:description, :user_id)
  end

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

end
