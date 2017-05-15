# Generated via
#  `rails generate hyrax:work GenericWork`

module Hyrax
  class GenericWorksController < ApplicationController
    include Hyrax::CurationConcernController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior

    self.curation_concern_type = GenericWork
  end
end
