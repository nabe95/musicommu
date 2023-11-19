class BandPost < ApplicationRecord
   belongs_to :user
   has_many :band_comments, dependent: :destroy
  
  validates :title,presence:true
  validates :body,presence:true
  validates :area,presence:true
  validates :instrument,presence:true
  validates :genre,presence:true

  # 活動日時(指定なし、平日、休日)
  enum activity: { unspecified: 0, weekdays: 1, holiday: 2 }
  # 活動の方針
  enum direction: { hobby:0, independent:1, pro: 2 }
  # バンドでやる楽曲の種類(指定なし、コピー、オリジナル)
  enum band_type: { notype: 0, copy: 1, original: 2 }
  # 投稿の公開と非公開
  enum status: { public: 0, private:1 }, _prefix: true
  
  def status_label
    case status.to_sym
    when :public
      '<span class="text-success">'.html_safe + I18n.t("enums.band_post.status.public") + '</span>'.html_safe
    when :private
      '<span class="text-danger">'.html_safe + I18n.t("enums.band_post.status.private") + '</span>'.html_safe
    else
      status.to_s
    end
  end

end