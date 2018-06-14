class CreateWorkZipJob < ApplicationJob
  queue_as :default

  def perform(work)
    working_dir = WorkZipCreator.working_dir
    FileUtils.mkdir_p(working_dir)
    tmp_file = Tempfile.new("zip_#{work.id}", working_dir).tap(&:binmode)
    WorkZipCreator.new(work.id).create_zip(filepath: tmp_file.path)
    tmp_file.rewind
    work.write_from_path(tmp_file.path)
  rescue StandardError => e
    Rails.application.log_error(e)
  ensure
    tmp_file.close
    tmp_file.unlink
  end
end
