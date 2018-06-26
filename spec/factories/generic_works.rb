FactoryBot.define do
  factory :generic_work, aliases: [:work], class: GenericWork do
    title ['Test title']
    creator ['Test creator']
    rights_statement ['http://rightsstatements.org/vocab/NKC/1.0/']
    description ['Test description']
    keyword ['Test keyword']
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    date_created ['197x']
    subject ['Just Northwestern Things']

    transient do
      user { FactoryBot.create(:user) }
      image_path { Rails.root + 'spec/fixtures/coffee.jpg' }
      num_images { 1 }
    end

    before(:create) do |work, evaluator|
      evaluator.num_images.times do |i|
        fileset = FactoryBot.create(:file_set,
                                    user: evaluator.user,
                                    title: ["#{File.basename(evaluator.image_path)}_#{i + 1}_#{evaluator.title.first}"],
                                    label: File.basename(evaluator.image_path),
                                    visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC)
        work.ordered_members << fileset
        work.representative = fileset
        work.thumbnail = fileset

        # Try to attach a real image
        IngestFileJob.perform_now(fileset, evaluator.image_path.to_s, evaluator.user)
      end
    end

    after(:build) do |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    end
  end
end
