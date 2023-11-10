class Post < ApplicationRecord
  belongs_to :user
  
  has_one_attached :image
  has_many :favorites, dependent: :destroy
  
  validates :title,presence:true
  validates :body,presence:true
  
  def get_image
    if image.attached?
      image
    else
      'no_image.jpg'
    end
  end
  
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
