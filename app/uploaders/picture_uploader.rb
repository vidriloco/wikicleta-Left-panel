# encoding: utf-8
require 'carrierwave/processing/mime_types'

class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  
  # Include RMagick or ImageScience support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :mini_thumb do
    process :resize_to_limit => [nil, 300]
  end
  
  version :thumb do
    process :resize_to_limit => [250, nil]
  end
  
  version :preview do
    process :resize_to_fill => [720, 370, ::Magick::CenterGravity]
  end

  def extension_white_list
     %w(jpg jpeg gif png)
  end

  def filename
     @name ||= "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end
