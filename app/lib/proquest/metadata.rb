class Proquest::Metadata
  attr_reader :metadata, :proquest_zip, :today

  def initialize(metadata_file, today = Time.zone.today)
    @metadata = File.open(metadata_file) { |f| Nokogiri::XML(f) }
    @proquest_zip = Pathname(metadata_file).parent.basename.to_s
    @today = today
  end

  def proquest_metadata
    [work_attributes, file_list]
  end

  private

    def work_attributes
      {
        admin_set_id: @admin_set_id,
        creator: creators,
        date_uploaded: today,
        depositor: Settings.dissertation_depositor,
        description: description,
        embargo_release_date: embargo_release_date,
        identifier: identifier,
        keyword: keywords.uniq.flatten,
        language: language,
        resource_type: ['Dissertation'],
        rights_statement: ['http://rightsstatements.org/vocab/InC/1.0/'],
        subject: subject,
        title: title,
        visibility_after_embargo: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC,
        visibility_during_embargo: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE,
        visibility: visibility
      }.reject! { |_k, v| v.blank? }
    end

    def file_list
      [].tap do |f|
        f << metadata.xpath('//DISS_content/DISS_binary').text
        metadata.xpath('//DISS_content/DISS_attachment').each do |file_name|
          f << file_name.xpath('DISS_file_name').text
        end
      end
    end

    def title
      Array(metadata.xpath('//DISS_description/DISS_title').text)
    end

    def creators
      metadata.xpath('//DISS_submission/DISS_authorship/DISS_author[@type="primary"]/DISS_name').map do |creator|
        format_name(creator)
      end.uniq.flatten
    end

    def keywords
      metadata.xpath('//DISS_description/DISS_categorization/DISS_keyword').text.split(', ')
    end

    def subject
      metadata.xpath('//DISS_description/DISS_categorization/DISS_category/DISS_cat_desc').map(&:text)
    end

    def description
      metadata.xpath('//DISS_content/DISS_abstract/DISS_para').map { |description| description.text.strip }
    end

    def identifier
      [metadata.xpath('//DISS_description/@external_id').text, proquest_zip]
    end

    def language
      Array(metadata.xpath('//DISS_description/DISS_categorization/DISS_language').text)
    end

    def visibility
      if embargo_release_date.present?
        Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
      else
        Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      end
    end

    def embargo_release_date # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
      release_date = [accept_date, today].max

      case embargo_code
      when 0
        release_date = accept_date
      when 1
        release_date += 6.months
      when 2
        release_date += 1.year
      when 3
        release_date += 2.years
      when 4
        release_date = remove_date.present? ? remove_date : today + 200.years
      end

      release_date < today ? nil : release_date.to_s
    end

    def embargo_code
      metadata.xpath('//DISS_submission/@embargo_code').text.to_i
    end

    def accept_date
      Date.strptime(metadata.xpath('//DISS_description/DISS_dates/DISS_accept_date').text, '%m/%d/%Y')
    end

    def remove_date
      Date.strptime(metadata.xpath('//DISS_sales_restriction/@remove').text, '%m/%d/%Y')
    end

    def format_name(person)
      [].tap do |name_parts|
        name_parts << person.xpath('DISS_surname').text
        name_parts << (person.xpath('DISS_fname').text + ' ' + person.xpath('DISS_middle').text).strip
        name_parts << person.xpath('DISS_suffix').text
      end.reject(&:blank?).join(', ')
    end
end
