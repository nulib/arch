module DoiBehavior
  extend ActiveSupport::Concern

  included do
    after_action :doi_check, only: :create
  end

  def doi_check
    if @curation_concern.doi.present?
      doi_link = "https://doi.org/#{@curation_concern.doi.split(':').last}"
      flash[:notice] = Array(flash[:notice]) << I18n.t('hyrax.works.create.after_create_doi_html', doi: doi_link)
    else
      flash[:error] = I18n.t('hyrax.works.create.after_create_no_doi_html')
    end
  end
end
