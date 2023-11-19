class Message < ApplicationRecord
  belongs_to :user
  belongs_to :group
  
  validates :message, presence: true, length: { maximum: 100 }
  
end
