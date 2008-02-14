# Quick script to download exported xml files from NietzscheSource for testing

require 'rexml/document'
require 'open-uri'

puts "Usage downloader.rb <list_file> [output_path (default .)]" unless(ARGV[0])
@output_path = ARGV[1]
@output_path ||= "."


def grab_siglum(siglum)
  open("http://www.nietzschesource.org/exportToTalia.php?get=#{siglum}", :http_basic_authentication => ["nietzsche", "source"]) do |io|
    open(File.join(@output_path, "#{siglum}.xml"), "w") do |file|
      file << io.read
    end
  end
end

xml_doc = REXML::Document.new
xml_doc.add_element("sigla")

open(ARGV[0]) do |file|
  file.each_line do |line|
    line.strip!
    unless(line == "" || line.include?(":") || line.include?(" "))
      puts "fetching #{line}"
      grab_siglum(line)
      el = xml_doc.root.add_element("siglum")
      el.add_text("#{line}.xml")
    end
  end
end

File.open(File.join(@output_path, "list.xml"), "w") do |file|
  xml_doc.write(file)
end