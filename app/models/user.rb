class User < ActiveRecord::Base
  has_many :slides
  has_many :photos, through: :slides
end
