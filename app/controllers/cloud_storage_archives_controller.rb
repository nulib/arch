class CloudStorageArchivesController < ApplicationController
  before_action do
    authorize! :show, presenter.solr_document
  end

  def zip
    record = CloudStorageArchive.find_or_create_record(work_id, work_presenter: presenter)

    render json: record.as_json(methods: (record.success? ? 'url' : nil))
  end

  protected

    def work_id
      @work_id = params.require(:id)
    end

    def presenter
      @presenter ||= Hyrax::GenericWorkPresenter.new(
        SolrDocument.find(work_id),
        Ability.new(current_user)
      )
    end
end
