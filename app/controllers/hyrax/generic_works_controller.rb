# frozen_string_literal: true

module Hyrax
  class GenericWorksController < ApplicationController
    # TODO: test the :doi_check after action
    after_action :doi_check, only: :create

    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::GenericWork
    self.search_builder_class = Wings::WorkSearchBuilder(::GenericWork)
    self.work_form_service = Hyrax::FormFactory.new

    private

      def doi_check
        if @curation_concern.doi.present?
          doi_link = "https://doi.org/#{@curation_concern.doi.split(':').last}"
          flash[:notice] = Array(flash[:notice]) << I18n.t('hyrax.works.create.after_create_doi_html', doi: doi_link)
        else
          flash[:error] = I18n.t('hyrax.works.create.after_create_no_doi_html')
        end
      end
  end
end
