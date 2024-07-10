class Video < ApplicationRecord
  has_one_attached :file
  belongs_to :user
  has_one :transcript, dependent: :destroy
end
