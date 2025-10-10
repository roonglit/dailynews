class Book < ApplicationRecord
  has_one_attached :pdf
  has_one_attached :cover
end
