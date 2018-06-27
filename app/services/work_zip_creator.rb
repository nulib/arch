class WorkZipCreator
  class_attribute :working_dir
  self.working_dir = Pathname.new(Dir.tmpdir).join('nulib_zip_create')

  attr_reader :work_id

  def initialize(work_id)
    @work_id = work_id
  end

  # Writes zip to specified path, if path not given will write to a tempfile, and return
  # it _without_ closing/unlinking it.
  def create_zip(filepath: nil, callback: nil)
    if filepath.nil?
      # See http://thinkingeek.com/2013/11/15/create-temporary-zip-file-send-response-rails/
      # for explanation of the way we are using Zip library that looks weird.

      FileUtils.mkdir_p working_dir
      tmp_file = Tempfile.new("zip-#{work_id}", working_dir).tap(&:binmode)
      Zip::OutputStream.open(tmp_file) { |z| }
      filepath = tmp_file.path
    end

    tmp_comment_file = Tempfile.new("zip-#{work_id}-comment", working_dir)
    tmp_comment_file.write(comment_text)
    tmp_comment_file.rewind

    count = work_presenter.public_member_presenters.size

    Zip::File.open(filepath, Zip::File::CREATE) do |zipfile|
      zipfile.comment = comment_text

      zipfile.add('about.txt', tmp_comment_file)

      work_presenter.public_member_presenters.each_with_index do |file_set_presenter, index|
        file_set = FileSet.find(file_set_presenter.id)
        filename = "#{format '%03d', index + 1}-#{file_set.label}"

        url = file_set.original_file.uri.value
        output = Pathname.new(working_dir).join(filename)

        open(url) do |io|
          IO.copy_stream(io, output)
        end

        zipfile.add(filename, output)

        callback&.call(progress_total: count, progress_i: index + 1)
      end
    end

    return tmp_file
  ensure
    tmp_comment_file.close
    tmp_comment_file.unlink
  end

  protected

    def work_presenter
      @work_presenter ||= begin
        solr_doc = SolrDocument.find(work_id) # CloudStorageArchive
        GenericWorkPresenter.new(solr_doc, Ability.new(nil))
      end
    end

    def comment_text
      @comment_text ||= <<~EOS
        Courtesy of Northwestern University Libraries
         #{work_presenter.title.first}
         Work #{work_id}
         Prepared on #{Time.zone.now}
      EOS
    end

  private

    def get_file_sets(presenter)
      presenter.member_presenters.each do |member|
        if member.is_a?(Hyrax::FileSetPresenter)
          @file_set_ids << member.id
        else
          get_file_sets(member)
        end
      end
    end
end
