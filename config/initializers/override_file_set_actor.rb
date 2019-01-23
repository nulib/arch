# override FileSetActor to add a file_set.reload
# https://github.com/samvera/hyrax/blob/master/app/actors/hyrax/actors/file_set_actor.rb
# otherwise characterization info being overritten in solr in dev environments
# rubocop:disable Metrics/AbcSize
Hyrax::Actors::FileSetActor.class_eval do
  # Adds a FileSet to the work using ore:Aggregations.
  # Locks to ensure that only one process is operating on the list at a time.
  def attach_file_to_work(work, file_set_params = {})
    acquire_lock_for(work.id) do
      file_set.save unless file_set.persisted?
      file_set.reload
      # Ensure we have an up-to-date copy of the members association, so that we append to the end of the list.
      work.reload unless work.new_record?
      copy_visibility(work, file_set) unless assign_visibility?(file_set_params)
      work.ordered_members << file_set
      set_representative(work, file_set)
      set_thumbnail(work, file_set)
      # Save the work so the association between the work and the file_set is persisted (head_id)
      # NOTE: the work may not be valid, in which case this save doesn't do anything.
      work.save
    end
  end
end
# rubocop:enable Metrics/AbcSize
