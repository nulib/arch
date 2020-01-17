class Proquest::Package
  attr_reader :s3_package, :temp_package_dir

  def initialize(s3_package)
    @s3_package = s3_package
    @temp_package_dir = temp_package_dir
  end

  def ingest
    extract_zip
    return nil unless File.file?(metadata_file) && File.file?(pdf_file)
    metadata, listed_files = Proquest::Metadata.new(metadata_file).proquest_metadata

    resource = ingest_work(metadata)
    listed_files.each do |f|
      file_path = unzipped_file_list.find { |e| e.match(f.to_s) }
      next unless File.file?(file_path)
      ingest_file_set(parent: resource,
                      resource: metadata.merge(title: [f]),
                      f: file_path)
    end
    s3_package.copy_to(bucket: s3_package.bucket.name, key: "_completed/#{s3_package.key}", multipart_copy: s3_package.size > 5.megabytes)
    s3_package.delete
  end

  private

    def temp_package_dir
      fname = File.basename(s3_package.key, File.extname(s3_package.key))
      dirname = Hyrax.config.working_path.join('proquest', fname)
      FileUtils.mkdir_p(dirname)
      dirname
    end

    def unzipped_file_path
      Pathname.new(temp_package_dir).join(File.basename(s3_package.key))
    end

    def unzipped_file_list
      Dir.glob("#{temp_package_dir}/**/*.*")
    end

    def download_zip
      File.open(unzipped_file_path, 'wb') do |file|
        s3_package.client.get_object({ bucket: s3_package.bucket.name, key: s3_package.key }, target: file)
      end
    end

    def extract_zip
      Zip::File.open(download_zip.body.path) do |zip_file|
        zip_file.each do |f|
          fpath = File.join(temp_package_dir, f.name)
          zip_file.extract(f, fpath) unless File.exist?(fpath)
        end
      end
    end

    def metadata_file
      Dir.glob("#{temp_package_dir}/*_DATA*.xml").first.to_s
    end

    def pdf_file
      Dir.glob("#{temp_package_dir}/*.pdf").first.to_s
    end

    def ingest_work(metadata)
      resource = GenericWork.new(metadata)
      resource.visibility = metadata[:visibility]
      if metadata[:embargo_release_date].present?
        resource.visibility_during_embargo = metadata[:visibility_during_embargo]
        resource.visibility_after_embargo = metadata[:visibility_after_embargo]
        resource.embargo_release_date = metadata[:embargo_release_date]
      end
      resource.save!
      resource.update(permissions_attributes: group_permissions(metadata[:admin_set_id])) if metadata[:admin_set_id].present?
      resource
    end

    def ingest_file_set(parent: nil, resource: nil, f: nil)
      file_set_metadata = file_record(resource)

      if file_set_metadata['embargo_release_date'].blank?
        file_set_metadata.except!('embargo_release_date', 'visibility_during_embargo', 'visibility_after_embargo')
      end
      file_set = FileSet.create(file_set_metadata)
      actor = Hyrax::Actors::FileSetActor.new(file_set, User.where(username: Settings.proquest.dissertation_depositor).first)
      actor.create_metadata(file_set_metadata)
      file = File.open(f)
      actor.create_content(file)
      actor.attach_to_work(parent)
      file.close

      file_set
    end

    def file_record(attrs) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      file_set = FileSet.new

      {}.tap do |file_attributes|
        # Singularize non-enumerable attributes and make sure enumerable attributes are arrays
        attrs.each do |k, v|
          next unless file_set.attributes.keys.member?(k.to_s)
          file_attributes[k] = if !file_set.attributes[k.to_s].respond_to?(:each) && file_attributes[k].respond_to?(:each)
                                 v.first
                               elsif file_set.attributes[k.to_s].respond_to?(:each) && !file_attributes[k].respond_to?(:each)
                                 Array(v)
                               else
                                 v
                               end
        end

        file_attributes[:date_created] = attrs[:date_created]
        file_attributes[:visibility] = attrs[:visibility]
        if attrs[:embargo_release_date].present?
          file_attributes[:embargo_release_date] = attrs[:embargo_release_date]
          file_attributes[:visibility_during_embargo] = attrs[:visibility_during_embargo]
          file_attributes[:visibility_after_embargo] = attrs[:visibility_after_embargo]
        end
      end
    end

    def group_permissions(admin_set_id)
      # find admin set and manager groups for work
      manager_groups = Hyrax::PermissionTemplateAccess.joins(:permission_template)
                                                      .where(access: 'manage', agent_type: 'group')
                                                      .where(permission_templates: { source_id: admin_set_id })

      # find admin set and viewer groups for work
      viewer_groups = Hyrax::PermissionTemplateAccess.joins(:permission_template)
                                                     .where(access: 'view', agent_type: 'group')
                                                     .where(permission_templates: { source_id: admin_set_id })

      # update work permissions to give admin set managers edit access and viewer groups read access
      permissions_array = []
      manager_groups.each do |manager_group|
        permissions_array << { 'type' => 'group', 'name' => manager_group.agent_id, 'access' => 'edit' }
      end
      viewer_groups.each do |viewer_group|
        permissions_array << { 'type' => 'group', 'name' => viewer_group.agent_id, 'access' => 'read' }
      end

      permissions_array
    end
end
