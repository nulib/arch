[FixityCheckJob, ImportExportJob, InheritPermissionsJob, ResolrizeJob, StreamNotificationsJob, VisibilityCopyJob].each do |klass|
  klass.class_eval { queue_as Hyrax.config.ingest_queue_name }
end
