class Post < ApplicationRecord
  belongs_to :user

  has_one_attached :image
  #コメント機能
  has_many :post_comments, dependent: :destroy
  #いいね機能
  has_many :favorites, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true

  #写真の登録がない場合のイメージ画像を
  def get_image
    if image.attached?
      image
    else
      'no_image2.jpg'
    end
  end

  #引数で渡されたpost_idがFavoritesテーブル内に存在するか確認
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  #部分検索　Post.search_for(@content)を@recordへ
  def self.search_for(content,method)
    if method == "both"
    Post.where('title LIKE?', '%'+content+'%').or(Post.where('body LIKE?', '%'+content+'%'))
    elsif  method == "title"
    Post.where('title LIKE?', '%'+content+'%')
    elsif method == "body"
      Post.where('body LIKE?', '%'+content+'%')
    end
  end

end
