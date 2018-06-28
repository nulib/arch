require 'rails_helper'

RSpec.describe 'hyrax/base/_form_files.html.erb', type: :view do
  let(:model) { FactoryBot.create(:work) }
  let(:form) { Hyrax::GenericWorkForm.new(model, nil, nil) }
  let(:current_user) { FactoryBot.create(:user) }
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <% if current_user.admin? %>
          <% if Hyrax.config.browse_everything? %>
            <h2><%= t('hyrax.base.form_files.external_upload') %></h2>
            <%= render 'browse_everything', f: f %>
          <% end %>
        <% end %>
      <% end %>
    )
  end

  before do
    assign(:form, form)
  end

  context 'with admin user' do
    before do
      allow(Hyrax.config).to receive(:browse_everything?).and_return(true)
      allow(view).to receive(:current_user).and_return(current_user)
      allow(current_user).to receive(:admin?).and_return(true)
      render inline: form_template
    end

    it 'shows the cloud files browser' do
      expect(rendered).to have_selector("button[id='browse-btn'][data-target='#edit_generic_work_#{form.model.id}']")
    end
  end

  context 'without admin user' do
    before do
      allow(Hyrax.config).to receive(:browse_everything?).and_return(true)
      allow(view).to receive(:current_user).and_return(current_user)
      allow(current_user).to receive(:admin?).and_return(false)
      render inline: form_template
    end

    it 'does not show the cloud files browser' do
      expect(rendered).not_to have_selector("button[id='browse-btn'][data-target='#edit_generic_work_#{form.model.id}']")
    end
  end
end
