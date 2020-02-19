# frozen_string_literal: true

class MediaFile < ApplicationRecord

  has_attachment :file_content

  validates :title, presence: true
  validates :file_content, presence: true, on: :update

  scope :actives, -> { where(active: true) }

  def path
    file_content.try(:fullpath)
  end

  def filename
    "#{title}.#{file_content.format}"
  end

end
