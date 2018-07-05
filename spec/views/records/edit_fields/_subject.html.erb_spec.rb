
require 'rails_helper'

RSpec.describe 'records/edit_fields/_subject.html.erb', type: :view do
  let(:work) { FactoryBot.create(:work) }
  let(:form) { Hyrax::GenericWorkForm.new(work, nil, nil) }
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "records/edit_fields/subject", f: f, key: 'subject' %>
      <% end %>
    )
  end

  before do
    assign(:form, form)
    render inline: form_template
  end

  it 'has url for autocomplete service' do
    expect(rendered).to have_selector('input[data-autocomplete-url="/authorities/search/assign_fast/all"][data-autocomplete="subject"]')
  end
end
