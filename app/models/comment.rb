# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer
#  photo_id   :integer
#

class Comment < ApplicationRecord
  validates(:author, {:presence => true })
  validates(:photo, {:presence => true })


  belongs_to :author, :class_name=>"User" # couldn't figure out how to use "commenter" method + "User" class + "author" id, so switched to have method and Id title to match

  # def commenter
  #   return User.where({ :id => self.author_id }).at(0)
  # end

  belongs_to (:photo)

  # def photo
  #   return Photo.where({ :id => self.photo_id }).at(0)
  # end
end
