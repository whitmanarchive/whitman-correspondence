class Datura::DataManager

  # read in the notes.xml file and keep it available for
  # individual files to refer to
  def pre_batch_processing
    path = File.join(@options["collection_dir"], "source/annotations/notes.xml")
    notes = CommonXml.create_xml_object(path)

    # I am not excited about storing a 92K line file
    # in memory for the duration of the script run,
    # but I am also not excited about reading / closing
    # it repeatedly for each document, so here we are 
    @options["notes"] = notes
  end


end
