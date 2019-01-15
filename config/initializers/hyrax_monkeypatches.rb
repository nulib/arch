FileSet.class_eval do
  before_save :decode_import_url
  before_save :ensure_label_present

  def decode_import_url
    return if import_url.nil?
    decoded_url = URI.decode(import_url)
    while import_url != decoded_url
      Rails.logger.info("Decoding #{import_url}")
      self.import_url = decoded_url
      decoded_url = URI.decode(import_url)
    end
  end

  def ensure_label_present
    return if label.present? || import_url.nil?
    self.label = File.basename(URI(import_url).path)
  end
end
