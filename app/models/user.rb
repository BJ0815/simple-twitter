class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader
  

  # 需要 app/views/devise 裡找到樣板，加上 name 屬性
  # 並參考 Devise 文件自訂表單後通過 Strong Parameters 的方法
  validates :name, presence: true, uniqueness: true
  # 加上驗證 name 不能重覆 (關鍵字提示: uniqueness)

  has_many :tweets, -> { order(created_at: :desc) }, dependent: :destroy

  has_many :followships, -> { order(created_at: :desc)}, dependent: :destroy
  has_many :followings, through: :followships

  has_many :inverse_followships, class_name: "Followship", foreign_key: "following_id"
  has_many :followers, through: :inverse_followships, source: :user

  has_many :likes, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet

  has_many :replies, dependent: :destroy

  def admin?
    self.role == "admin"
  end

  def following?(other_user)
    followings.include?(other_user)
  end

  def like?(tweet)
    likes.where(tweet: tweet).exists?
  end

  def self.order_tweets
    all.sort { |x,y| x.tweets.size <=> y.tweets.size }.reverse
  end


end
