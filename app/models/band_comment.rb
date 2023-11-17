class BandComment < ApplicationRecord
  belongs_to :user
  belongs_to :band_post
  
  validates :comment, presence: true

end
