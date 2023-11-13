class BandComment < ApplicationRecord
  belongs_to :user
  belongs_to :band_post
end
