class TeiToEs

  ################
  #    XPATHS    #
  ################

  # in the below example, the xpath for "person" is altered
  def override_xpaths
    xpaths = {}
    xpaths["person"] = "/TEI/teiHeader/profileDesc/particDesc/person"
    return xpaths
  end

  #################
  #    GENERAL    #
  #################

  # do something before pulling fields
  def preprocessing
  end

  # Add more fields
  #  make sure they follow the custom field naming conventions
  #  *_d, *_i, *_k, *_t
  def assemble_collection_specific
    # TODO do we need whitman_citation_s ?
    # TODO whitman_source_sort_s....is this needed ?
    # @json["volume_k"] = @volume
  end

  ################
  #    FIELDS    #
  ################

  # Overrides of default behavior
  # Please see docs/tei_to_es.rb for complete instructions and examples

  def category
    "biography"
  end

  def creator
    creators = get_list(@xpaths["creators"])
    return creators.map do |creator| {
      "name" => CommonXml.normalize_space(creator),
      "role" => "sender"
    }
    end
  end

  def format
    "correspondence"
  end

  def language
    # TODO verify that none of these are primarily english
    "en"
  end

  def languages
    # TODO verify that none of these are multiple languages
    [ "en" ]
  end

  # TODO place is not going to be particularly easy to grab because of how places
  # have been encoded :(

  def recipient
    eles = @xml.xpath(@xpaths["recipient"])
    people = eles.map do |p|
      {
        "id" => "",
        "name" => CommonXml.normalize_space(p["key"]),
        "role" => "recipient"
      }
    end
    return people
  end

  # TODO publisher, rights, rights_uri, rights_holder, source

  def subcategory
    "correspondence"
  end

  # TODO text footnotes
  # pull from //ptr and select from notes.xml

  def uri
    "#{@options["site_url"]}/biography/correspondence/tei/#{@filename}.html"
  end

end