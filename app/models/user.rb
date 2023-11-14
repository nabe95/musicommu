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

  validates :name, length:{ minimum:2, maximum: 20}, uniqueness: true
  validates :introduction, length: {maximum: 50}
  validates :age, presence: true
  validates :prefecture, presence: true

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
      user.age = "00"
      user.prefecture = "？"
    end
  end

end
