class User < ApplicationRecord
  has_one_attached :avatar
  validates :avatar,
            content_type: [:png, :jpg, message: 'Uploaded image is neither a JPG nor PNG image'],
            size: { less_than: 200.kilobytes, message: "asd"}
end
