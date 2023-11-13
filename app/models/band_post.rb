class BandPost < ApplicationRecord
   belongs_to :user
   has_many :band_comments, dependent: :destroy
  
  validates :title,presence:true
  validates :body,presence:true
  validates :area,presence:true
  validates :instrument,presence:true
  validates :genre,presence:true

  enum activity: { unspecified: 0, weekdays: 1, holiday: 2 }
  enum direction: { hobby:0, independent:1, pro: 2 }
  enum band_type: { notype: 0, copy: 1, original: 2 }

end