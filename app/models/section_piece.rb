class SectionPiece < ActiveRecord::Base
  extend FriendlyId
  has_many  :section_piece_params
  friendly_id :title, :use => :slugged
end
