FactoryBot.define do
  factory :dataset, class: Dataset do
    title { ['Test title'] }
    creator { ['Test creator'] }
    rights_statement { ['http://rightsstatements.org/vocab/NKC/1.0/'] }
    description { ['Test description'] }
    visibility { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
    date_created { ['2021'] }
    subject { ['Just Northwestern Things'] }

    contact_information { ['Test contact information'] }
    related_citation { ['Test citation'] }

    transient do
      user { FactoryBot.create(:user) }
      image_path { Rails.root + 'spec/fixtures/files/coffee.jpg' }
      num_images { 1 }
    end

    before(:create) do |work, evaluator|
      evaluator.num_images.times do |i|
        fileset = FactoryBot.create(:file_set,
                                    user: evaluator.user,
                                    title: ["#{File.basename(evaluator.image_path)}_#{i + 1}_#{evaluator.title.first}"],
                                    label: File.basename(evaluator.image_path),
                                    visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC,
                                    content: File.open(evaluator.image_path))
        work.ordered_members << fileset
        work.representative = fileset
        work.thumbnail = fileset
      end
    end

    after(:build) do |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    end
  end
end
