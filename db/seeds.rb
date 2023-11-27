# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#管理者の設定
Admin.create!(email: "musicommu@admin.com", password: "musicommu")

# ユーザープロフィール
def random_introduction(genre)
  introductions = [
    "音楽大好きで特に#{genre}をよく聞きます",
    "#{genre}アーティストのファンで演奏するのが好きです",
    "音楽制作が好きで最近は#{genre}の曲作りをします",
    "#{genre}を自己流で楽しむアマチュアミュージシャンです",
    "#{genre}ファンとしてライブやフェスに参加します"
  ]
  introductions.sample
end

#ユーザー
10.times do |n|
  selected_genre = ["ロック", "ポップ", "パンク", "ジャズ", "メタル"].sample

  user = User.create!(
    email: "user#{n + 1}@example.com",
    name: "おんぷ#{n + 1}",
    password: "password#{n + 1}",
    password_confirmation: "password#{n + 1}",
    introduction: random_introduction(selected_genre),
    prefecture: ["東京都", "千葉県", "埼玉県", "神奈川県"].sample,
    age: rand(18..60),
    genre: selected_genre,
    artist: ["アーティスト1", "アーティスト2", "アーティスト3", "アーティスト4", "アーティスト5"].sample,
    is_active: true
  )
  user.profile_image.attach(io: File.open(Rails.root.join("app/assets/images/profile/#{user.id}.jpg")), filename: "#{user.id}.jpg")

end

# タグ
tags = ["ロック", "ポップ", "パンク", "ジャズ", "メタル"]

tags.each do |tag_name|
  Tag.find_or_create_by(name: tag_name)
end

10.times do |n|
  user = User.find_by(id: rand(1..10)) # ランダムにユーザーを取得

  post = Post.create!(
    user: user,
    title: "ライブ#{n + 1}",
    body: "楽しかった"
  )
  #タグづけ
  tag_list = [tags.sample]
  post.save_tags(tag_list)
  #画像
  image_path = Rails.root.join("app/assets/images/post/#{post.id}.jpg")
  post.image.attach(io: File.open(image_path), filename: "#{post.id}.jpg")
end

#メンバー募集
10.times do |n|
  user = User.find_by(id: rand(1..10))
  selected_genre = ["ロック", "ポップ", "パンク", "ジャズ", "メタル"].sample
  
  BandPost.create!(
    user: user,
    title: "#{selected_genre}バンドしませんか！#{n + 1}",
    body: "一緒にバンドをしましょう",
    area: ["東京都", "千葉県", "埼玉県", "神奈川県"].sample,
    instrument: ["ギター", "ベース", "ドラム", "キーボード", "ボーカル"].sample,
    genre: selected_genre,
    activity: rand(0..2), # 活動レベル
    direction: rand(0..2), # 音楽の方向性
    band_type: rand(0..2), # バンドのタイプ
    status: 0
  )
end

#グループ作成
["ロック", "ポップ", "パンク", "ジャズ", "メタル"].each do |genre|
  1.times do |n|
    owner_user = User.find_by(id: rand(1..10))
    group = Group.new(
      name: "#{genre}好き歓迎!",
      introduction: "#{genre}好きな方語り合いましょう!!",
      owner: owner_user
    )
    group.users << owner_user
    group.save!
  end
end

# いいね（Favorite）
Post.all.each do |post|
  user_ids = User.pluck(:id).sample(rand(1..4))

  user_ids.each do |user_id|
    Favorite.find_or_create_by!(user_id: user_id, post: post)
  end
end

# 投稿のコメント（PostComment）
comments = [
  "素敵な投稿ですね！",
  "感動しました！",
  "かっこいいです！",
  "楽しそうなライブでしたね。",
  "また聴きたいです。",
]

10.times do
  post_id = rand(1..10)
  # 投稿をしたユーザー以外のユーザー
  user_id = (User.pluck(:id) - [Post.find(post_id).user_id]).sample
  comment = comments.sample

  PostComment.create!(
    user_id: user_id,
    post_id: post_id,
    comment: comment
  )
end

# 募集のコメント（BandComment）
10.times do
  band_post_id = rand(1..10)
  user_id = rand(1..10)

  BandComment.create!(
    user_id: user_id,
    band_post_id: band_post_id,
    comment: "参加したいです！"
  )
end

# フォロー
15.times do
  follower = User.all.sample
  followed = User.where.not(id: follower.id).sample

  Relationship.find_or_create_by!(
    follower_id: follower.id,
    followed_id: followed.id
  )
end