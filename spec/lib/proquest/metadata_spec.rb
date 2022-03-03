require 'rails_helper'

RSpec.describe Proquest::Metadata do
  let(:today) { Time.zone.parse('2019-10-31').to_date }

  describe '#proquest_metadata' do
    context 'etd with embargo code 0 (no embargo)' do
      let(:xml) { "#{file_fixture_path}/proquest/northwestern_0000_DATA_embargo_code_0.xml" }
      let(:record) { described_class.new(xml, today) }

      it 'extracts metadata (without an embargo) and file list' do
        expect(record.proquest_metadata).to eq([{ admin_set_id: AdminSet::DEFAULT_ID,
                                                  creator: ['Last, First Middle'],
                                                  date_created: ['2019-01-01'],
                                                  date_uploaded: today,
                                                  depositor: 'registered',
                                                  description: ['Lorem ipsum. Dolor sit amet.'],
                                                  file_set_visibility: 'open',
                                                  identifier: ['http://dissertations.umi.com/northwestern:12345', 'proquest'],
                                                  keyword: ['keyword1', 'keyword2'],
                                                  language: ['en'],
                                                  resource_type: ['Dissertation'],
                                                  rights_statement: ['http://rightsstatements.org/vocab/InC/1.0/'],
                                                  subject: ['Architecture', 'Quantum physics', 'Animal behavior'],
                                                  title: ['Dissertation No Embargo'],
                                                  work_visibility_after_embargo: 'open',
                                                  work_visibility_during_embargo: 'restricted',
                                                  work_visibility: 'open' }, ['test_0000.pdf']])
      end
    end

    context 'etd with embargo code 1 (6 months)' do
      let(:xml) { "#{file_fixture_path}/proquest/northwestern_1111_DATA_embargo_code_1.xml" }
      let(:record) { described_class.new(xml, today) }

      it 'extracts metadata with embargo and file list' do
        metadata, file_list = record.proquest_metadata
        expect(metadata[:work_visibility]).to eq 'restricted'
        expect(metadata[:embargo_release_date].to_s).to eq((today + 6.months).to_s)
        expect(file_list).to eq ['test_1111.pdf']
      end
    end

    context 'etd with embargo code 2 (1 year)' do
      let(:xml) { "#{file_fixture_path}/proquest/northwestern_2222_DATA_embargo_code_2.xml" }
      let(:record) { described_class.new(xml, today) }

      it 'extracts metadata with embargo and file list' do
        metadata, file_list = record.proquest_metadata
        expect(metadata[:work_visibility]).to eq 'restricted'
        expect(metadata[:embargo_release_date].to_s).to eq((today + 1.year).to_s)
        expect(file_list).to eq ['test_2222.pdf']
      end
    end

    context 'etd with embargo code 3 (2 years)' do
      let(:xml) { "#{file_fixture_path}/proquest/northwestern_3333_DATA_embargo_code_3.xml" }
      let(:record) { described_class.new(xml, today) }

      it 'extracts metadata with embargo and file list' do
        metadata, file_list = record.proquest_metadata
        expect(metadata[:work_visibility]).to eq 'restricted'
        expect(metadata[:embargo_release_date].to_s).to eq((today + 2.years).to_s)
        expect(file_list).to eq ['test_3333.pdf']
      end
    end

    context 'etd with embargo code 4 (remove date or forever)' do
      let(:xml) { "#{file_fixture_path}/proquest/northwestern_4444_DATA_embargo_code_4.xml" }
      let(:record) { described_class.new(xml, today) }

      it 'extracts metadata with embargo and file list' do
        metadata, file_list = record.proquest_metadata
        expect(metadata[:work_visibility]).to eq 'restricted'
        expect(metadata[:embargo_release_date].to_s).to eq '2020-10-03'
        expect(file_list).to eq ['test_4444.pdf']
      end
    end

    context 'DISS_access_option open' do
      let(:xml) { "#{file_fixture_path}/proquest/northwestern_0000_DATA_diss_access_option_open.xml" }
      let(:record) { described_class.new(xml, today) }

      it 'sets work visibility and file set visibility to open' do
        metadata, _file_list = record.proquest_metadata
        expect(metadata[:file_set_visibility]).to eq 'open'
        expect(metadata[:work_visibility]).to eq 'open'
      end
    end

    context 'DISS_access_option open with an embargo' do
      let(:xml) { "#{file_fixture_path}/proquest/northwestern_0000_DATA_diss_access_option_open_with_embargo.xml" }
      let(:record) { described_class.new(xml, today) }

      it 'sets work visibility and file set visibility to private' do
        metadata, _file_list = record.proquest_metadata
        expect(metadata[:file_set_visibility]).to eq 'restricted'
        expect(metadata[:work_visibility]).to eq 'restricted'
      end
    end

    context 'DISS_access_option campus use only' do
      let(:xml) { "#{file_fixture_path}/proquest/northwestern_0000_DATA_diss_access_option_campus.xml" }
      let(:record) { described_class.new(xml, today) }

      it 'sets work visibility to open and file set visibility to authenticated' do
        metadata, _file_list = record.proquest_metadata
        expect(metadata[:file_set_visibility]).to eq 'authenticated'
        expect(metadata[:work_visibility]).to eq 'open'
      end
    end

    context 'DISS_access_option element not present' do
      let(:xml) { "#{file_fixture_path}/proquest/northwestern_0000_DATA_diss_access_option_not_present.xml" }
      let(:record) { described_class.new(xml, today) }

      it 'sets work visibility to open and file set visibility to private' do
        metadata, _file_list = record.proquest_metadata
        expect(metadata[:file_set_visibility]).to eq 'restricted'
        expect(metadata[:work_visibility]).to eq 'open'
      end
    end
  end
end
