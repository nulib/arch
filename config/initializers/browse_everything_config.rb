if Settings.aws.buckets.dropbox
  settings = { bucket: Settings.aws.buckets.dropbox, response_type: :signed_url }
  BrowseEverything.configure('s3' => settings)
end

if Settings.browse_everything.file_system.home
  settings = { home: Settings.browse_everything.file_system.home }
  BrowseEverything.configure('file_system' => settings)
end

if Settings.browse_everything.box.client_id
  settings = { client_id: Settings.browse_everything.box.client_id, client_secret: Settings.browse_everything.box.client_secret }
  BrowseEverything.configure('box' => settings)
end
