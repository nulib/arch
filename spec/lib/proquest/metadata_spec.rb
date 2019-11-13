require 'rails_helper'

RSpec.describe Proquest::Metadata do
  let(:today) { Date.parse('2019-10-31') }

  describe '#proquest_metadata' do
    context 'etd with embargo code 0 (no embargo)' do
      let(:xml) { "#{file_fixture_path}/proquest/northwestern_0000_DATA_embargo_code_0.xml" }
      let(:record) { described_class.new(xml, today) }

      it 'extracts metadata (without an embargo) and file list' do
        expect(record.proquest_metadata).to eq([{ creator: ['Last, First Middle'],
                                                  identifier: ['http://dissertations.umi.com/northwestern:12345'],
                                                  keyword: ['keyword1', 'keyword2', 'Architecture', 'Quantum physics', 'Animal behavior'],
                                                  language: ['en'],
                                                  resource_type: ['Dissertation'],
                                                  rights_statement: ['http://rightsstatements.org/vocab/InC/1.0/'],
                                                  title: ['Dissertation No Embargo'],
                                                  visibility_after_embargo: 'open',
                                                  visibility_during_embargo: 'restricted',
                                                  visibility: 'open' }, ['test_0000.pdf']])
      end
    end

    context 'etd with embargo code 1 (6 months)' do
      let(:xml) { "#{file_fixture_path}/proquest/northwestern_1111_DATA_embargo_code_1.xml" }
      let(:record) { described_class.new(xml, today) }

      it 'extracts metadata with embargo and file list' do
        metadata, file_list = record.proquest_metadata
        expect(metadata[:visibility]).to eq 'restricted'
        expect(metadata[:embargo_release_date].to_s).to eq((today + 6.months).to_s)
        expect(file_list).to eq ['test_1111.pdf']
      end
    end

    context 'etd with embargo code 2 (1 year)' do
      let(:xml) { "#{file_fixture_path}/proquest/northwestern_2222_DATA_embargo_code_2.xml" }
      let(:record) { described_class.new(xml, today) }

      it 'extracts metadata with embargo and file list' do
        metadata, file_list = record.proquest_metadata
        expect(metadata[:visibility]).to eq 'restricted'
        expect(metadata[:embargo_release_date].to_s).to eq((today + 1.year).to_s)
        expect(file_list).to eq ['test_2222.pdf']
      end
    end

    context 'etd with embargo code 3 (2 years)' do
      let(:xml) { "#{file_fixture_path}/proquest/northwestern_3333_DATA_embargo_code_3.xml" }
      let(:record) { described_class.new(xml, today) }

      it 'extracts metadata with embargo and file list' do
        metadata, file_list = record.proquest_metadata
        expect(metadata[:visibility]).to eq 'restricted'
        expect(metadata[:embargo_release_date].to_s).to eq((today + 2.years).to_s)
        expect(file_list).to eq ['test_3333.pdf']
      end
    end

    context 'etd with embargo code 4 (remove date or forever)' do
      let(:xml) { "#{file_fixture_path}/proquest/northwestern_4444_DATA_embargo_code_4.xml" }
      let(:record) { described_class.new(xml, today) }

      it 'extracts metadata with embargo and file list' do
        metadata, file_list = record.proquest_metadata
        expect(metadata[:visibility]).to eq 'restricted'
        expect(metadata[:embargo_release_date].to_s).to eq '2020-10-03'
        expect(file_list).to eq ['test_4444.pdf']
      end
    end
  end
end
