class TeiToEs

  ################
  #    XPATHS    #
  ################

  # in the below example, the xpath for "person" is altered
  def override_xpaths
    xpaths = {}
    xpaths["annotations"] = "//ptr/@target"
    # used to be multiple places but cutting editors out for now
    xpaths["contributors"] = [ "/TEI/teiHeader/fileDesc/titleStmt/respStmt/persName" ]
    xpaths["creators"] = "/TEI/teiHeader/profileDesc/particDesc/person[@role='sender']/persName/@key"
    xpaths["person"] = "/TEI/teiHeader/profileDesc/particDesc/person"
    xpaths["recipient"] = "/TEI/teiHeader/profileDesc/particDesc/person[@role='recipient']/persName/@key"
    xpaths["rights"] = "/TEI/teiHeader/fileDesc/publicationStmt/availability"
    xpaths["source"] = {
      "monogr" => "//biblStruct/monogr",
      "author" => "//biblStruct/monogr/author",
      "title" => "//biblStruct/monogr/title",
      "editor" => "//biblStruct/monogr/editor",
      "pub_place" => "//biblStruct/monogr/imprint/pubPlace",
      "publisher" => "//biblStruct/monogr/imprint/publisher",
      "date" => "//biblStruct/monogr/imprint/date",
      "volume" => "//biblStruct/monogr/imprint/biblScope[@type='volume']",
      "pages" => "//biblStruct/monogr/imprint/biblScropt[@type='page']"
    }
    xpaths
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

  def annotations_text
    targets = @xml.xpath(@xpaths["annotations"])
    targets.map do |target|
      get_text("//note[@id='#{target}']", false, @options["notes"])
    end
  end

  def category
    "biography"
  end

  # format: do not include format
  def format
  end

  def language
    "en"
  end

  def languages
    [ "en" ]
  end

  # medium: do not include medium
  def medium
  end

  # place: should not include places at this point in time

  def person
    eles = @xml.xpath(@xpaths["person"])
    eles.map do |p|
      pname = p.xpath("persName").first["key"]
      {
        "id" => "",
        "name" => Datura::Helpers.normalize_space(pname),
        "role" => Datura::Helpers.normalize_space(p["role"])
      }
    end
  end

  def rights
    get_text(@xpaths["rights"])
  end

  # source follows this pattern:
  # [author], <em>[title]</em>, ed. [editor]
  # ([pub_place]: [publisher], [date])
  # [volume]:[pages]
  def source
    s = @xpaths["source"]
    if @xml.xpath(s["monogr"]).length > 0
      s_auth = get_text(s["author"])
      s_titl = get_text(s["title"])
      s_edit = get_text(s["editor"])
      s_pbpl = get_text(s["pub_place"])
      s_publ = get_text(s["publisher"])
      s_date = get_text(s["date"])
      s_volu = get_text(s["volume"])
      s_page = get_text(s["pages"])

      # TODO check for edgecases where not all of these
      # fields exist and design accordingly
      auth_line = "#{s_auth}, <em>#{s_titl}</em>, ed. #{s_edit}"
      publ_line = "(#{s_pbpl}: #{s_publ}, #{s_date})"
      volu_line = "#{s_volu}:#{s_page}"

      "#{auth_line} #{publ_line}, #{volu_line}"
    end
  end

  def subcategory
    "correspondence"
  end

  def topics
    # TODO determine if this is an okay field for this once other projects
    # start using topics, or if there needs to be a custom field
    if date
      year = date[/^\d{4}/]
      case year.to_i
      when 0..1859
        "Early"
      when 1860..1866
        "Civil War (1860-1866)"
      when 1867..1876
        "Reconstruction (1867-1876)"
      when 1877..1887
        "Post Reconstruction (1877-1887)"
      when 1888..1892
        "Old Age (1888-1892)"
      else
        "No Era Assigned"
      end
    end
  end

  # TODO text footnotes
  # pull from //ptr and select from notes.xml

  def uri
    "#{@options["site_url"]}/biography/correspondence/tei/#{@filename}.html"
  end

end
