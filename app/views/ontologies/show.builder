xml.instruct!

TaliaCore::ActiveSourceParts::Xml::RdfBuilder.open(:builder => xml) do |builder| # Create from the default builder passed to this template
  @triples.each do |onto_triple|
    builder.write_triple(*onto_triple)
  end
end