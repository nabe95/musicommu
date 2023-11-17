class Post < ApplicationRecord
  belongs_to :user

  #投稿イメージ写真を載せる
  has_one_attached :image
  #コメント機能
  has_many :post_comments, dependent: :destroy
  #いいね機能
  has_many :favorites, dependent: :destroy
  # タグ機能
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

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

  #部分 キーワード検索　Post.search_for(@content)を@recordへ
  def self.search_for(content,method)
    #タイトルと本文内を検索
    if method == "both"
    Post.where('title LIKE?', '%'+content+'%').or(Post.where('body LIKE?', '%'+content+'%'))
    #タイトルを検索
    elsif  method == "title"
    Post.where('title LIKE?', '%'+content+'%')
    #本文内を検索
    elsif method == "body"
    Post.where('body LIKE?', '%'+content+'%')
    end
  end
  
  #タグ機能
  def save_tags(tags)
    #存在しているタグの場合、配列として全て取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 取得したタグから送られてきたタグを除いてoldタグにする
    old_tags = current_tags - tags
    #送信されてきたタグから存在していないタグをnewとする
    new_tags = tags - current_tags
    #oldタグを消去
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name: old_name)
    end
    #新しいタグを保存
    new_tags.each do |new_name|
      tag = Tag.find_or_create_by(name: new_name)
      self.tags << tag
    end
  end
end
