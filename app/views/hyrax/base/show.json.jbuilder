json.extract! @curation_concern, *[:id, :member_of_collections, :thumbnail_id] + @curation_concern.class.fields.reject { |f| [:has_model].include? f }
json.version @curation_concern.etag
