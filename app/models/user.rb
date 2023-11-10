class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :posts, dependent: :destroy
  #コメント機能
  has_many :post_comments, dependent: :destroy
  #いいね
  has_many :favorites, dependent: :destroy

  validates :name, length:{ minimum:2, maximam: 20}, uniqueness: true
  validates :introduction, length: {maximum: 50}
  validates :age, presence: true
  validates :prefectures, presence: true

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

end
