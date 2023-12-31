class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :posts, dependent: :destroy
  has_many :band_posts, dependent: :destroy
  #コメント機能
  has_many :post_comments, dependent: :destroy
  #バント募集コメント機能
  has_many :band_comments, dependent: :destroy
  #いいね
  has_many :favorites, dependent: :destroy
  #グループ機能
  has_many :group_users, dependent: :destroy
  # グループチャットメッセージ
  has_many :messages, dependent: :destroy
  # フォローをした、された
  has_many :followers, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followeds, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 自分がフォローをした、された
  has_many :following_users, through: :followers, source: :followed
  has_many :follower_users, through: :followeds, source: :follower

  validates :name, length:{ minimum:2, maximum: 20}, uniqueness: true
  validates :introduction, length: {maximum: 30}
  validates :age, presence: true
  validates :prefecture, presence: true
  validates :genre, length: {maximum: 10}
  validates :artist, length: {maximum: 30}
  
  #プロフィールの写真
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  #ゲストログイン
  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
      user.age = "0"
      user.prefecture = "日本"
    end
  end

  #会員ステータス
  def user_status
    if is_active == false
      "退会"
    else
      "有効"
    end
  end

  #退会したら同じアカウントでログインできない
  def active_for_authentication?
    super && (is_active == true)
  end

  #フォローした時
  def follow(user_id)
    followers.create(followed_id: user_id)
  end
  
  #フォロー外す時
  def unfollow(user_id)
    followers.find_by(followed_id: user_id).destroy
  end
  
  #フォローされているか確認
  def following?(user)
    following_users.include?(user)
  end
  
end
