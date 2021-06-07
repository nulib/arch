# Generated via
#  `rails generate hyrax:work Dataset`
module Hyrax
  # Generated form for Dataset
  class DatasetForm < Hyrax::Forms::WorkForm
    self.model_class = ::Dataset
    self.terms += [:alternate_identifier, :bibliographic_citation, :contact_information, :related_citation, :resource_type]
    self.required_fields += [:date_created, :description, :license]
    self.required_fields -= [:keyword, :rights_statement]
  end
end
