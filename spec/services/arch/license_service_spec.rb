require 'rails_helper'

RSpec.describe Arch::LicenseService do
  before do
    qa_fixtures = { local_path: File.expand_path('config/authorities') }
    allow(Qa::Authorities::Local).to receive(:config).and_return(qa_fixtures)
  end

  context 'generic work licenses' do
    let(:generic_work_service) { described_class.new('generic_work_licenses') }

    describe '#select_active_options' do
      it 'returns active terms' do
        expect(generic_work_service.select_active_options.size).to eq 8
      end

      it 'does not return inactive terms' do
        expect(generic_work_service.select_active_options).not_to include([['Attribution 3.0 United States', 'http://creativecommons.org/licenses/by/3.0/us/']])
      end
    end

    describe '#select_all_options' do
      it 'returns both active and inactive terms' do
        expect(generic_work_service.select_all_options.size).to eq 16
      end
    end

    describe '#label' do
      it 'resolves for ids of active terms' do
        expect(generic_work_service.label('https://creativecommons.org/licenses/by-sa/4.0/')).to eq('Creative Commons BY-SA Attribution-ShareAlike 4.0 International')
      end

      it 'resolves for ids of inactive terms' do
        expect(generic_work_service.label('http://creativecommons.org/licenses/by-nc-sa/3.0/us/')).to eq('Attribution-NonCommercial-ShareAlike 3.0 United States')
      end
    end
  end

  context 'dataset licenses' do
    let(:dataset_service) { described_class.new('dataset_licenses') }

    describe '#select_active_options' do
      it 'returns active terms' do
        expect(dataset_service.select_active_options.size).to eq 2
      end
    end

    describe '#select_all_options' do
      it 'returns both active and inactive terms' do
        expect(dataset_service.select_all_options.size).to eq 2
      end
    end

    describe '#label' do
      it 'resolves for ids of active terms' do
        expect(dataset_service.label('http://opendatacommons.org/licenses/by/1.0/')).to eq('Open Data Commons Attribution License (ODC-By)')
      end
    end
  end

  context 'licenses fallback' do
    let(:service) { described_class.new }

    describe '#select_active_options' do
      it 'returns active terms' do
        expect(service.select_active_options.size).to eq 9
      end

      it 'does not return inactive terms' do
        expect(service.select_active_options).not_to include([['Attribution 3.0 United States', 'http://creativecommons.org/licenses/by/3.0/us/']])
      end
    end

    describe '#select_all_options' do
      it 'returns both active and inactive terms' do
        expect(service.select_all_options.size).to eq 17
      end
    end

    describe '#label' do
      it 'resolves for ids of active terms' do
        expect(service.label('https://creativecommons.org/licenses/by-sa/4.0/')).to eq('Creative Commons BY-SA Attribution-ShareAlike 4.0 International')
      end

      it 'resolves for ids of inactive terms' do
        expect(service.label('http://creativecommons.org/licenses/by-nc-sa/3.0/us/')).to eq('Attribution-NonCommercial-ShareAlike 3.0 United States')
      end
    end
  end
end
