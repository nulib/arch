class RemoteArchiveJob < ApplicationJob
  queue_as :default

  def perform(archive)
    working_dir = WorkZipCreator.working_dir
    FileUtils.mkdir_p(working_dir)
    tmp_file = Tempfile.new("zip_#{archive.id}", working_dir).tap(&:binmode)
    create_and_upload_archive(archive, tmp_file)
  rescue StandardError => e
    Rails.logger.error e
    archive.update(status: 'error', error_info: { class: e.class.name, message: e.message, backtrace: e.backtrace }.to_json)
  ensure
    cleanup_tmp_file(tmp_file)
  end

  private

    def create_and_upload_archive(archive, tmp_file)
      WorkZipCreator.new(archive.work_id).create_zip(filepath: tmp_file.path, callback: lambda do |progress_i:, progress_total:|
        archive.update(progress: progress_i, progress_total: progress_total)
      end)
      tmp_file.rewind
      archive.write_from_path(tmp_file.path)
      archive.update(status: 'success', byte_size: tmp_file.size)
    end

    def cleanup_tmp_file(tmp_file)
      tmp_file.close
      tmp_file.unlink
    end
end
