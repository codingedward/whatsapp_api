require 'shrine'

case Rails.env
when 'test'
  require 'shrine/storage/memory'
  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new
  }
else 
  require 'shrine/storage/file_system'
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads')
  }
end

Shrine.plugin :logging, logger: Rails.logger
Shrine.plugin :activerecord
Shrine.plugin :determine_mime_type
Shrine.plugin :remove_invalid
Shrine.plugin :restore_cached_data
Shrine.plugin :delete_promoted unless Rails.env.test?
