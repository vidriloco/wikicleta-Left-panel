if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      :provider           => 'Rackspace',
      :rackspace_username => 'vidriloco',
      :rackspace_api_key  => 'ecd0d0ca89092f8299f4d8178ab823bb'
    }
    config.fog_directory = 'wikicleta'
    config.fog_host = "http://c13774363.r63.cf2.rackcdn.com"
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end