# Quick script to download exported xml files from NietzscheSource for testing

require 'rexml/document'
require 'open-uri'
require 'progressbar'

# puts "Usage hyper_downloader.rb <list_file> [output_path (default .)]" unless(ARGV[0])
@output_path = ARGV[0]
@output_path ||= "."


def grab_siglum(siglum)
  begin
    open("http://www.nietzschesource.org/exportToTalia.php?get=#{siglum}", :http_basic_authentication => ["nietzsche", "source"]) do |io|
      open(File.join(@output_path, "#{siglum}.xml"), "w") do |file|
        file << io.read
      end
    end
  rescue Exception => e
    puts "Could not fetch: #{siglum}: #{e}"
  end
end

xml_doc = nil

open("http://www.nietzschesource.org/exportToTalia.php?getList=all", :http_basic_authentication => ["nietzsche", "source"]) do |io|
  xml_doc = REXML::Document.new(io.read)
end

puts "Fetching #{xml_doc.root.elements.size} elements"

progress = ProgressBar.new("Downloading", xml_doc.root.elements.size)

xml_doc.root.elements.each("siglum") do |element|
  progress.inc
  grab_siglum(element.text.strip)
end

progress.finish
  