class Photo < ActiveRecord::Base
  belongs_to :slide
  belongs_to :user
end
