#!/usr/bin/ruby

$: << File.dirname(__FILE__)

# Quick script to download exported xml files from NietzscheSource for testing
require 'progressbar'
require File.join(File.dirname(__FILE__), '..', 'hyper_download')

output_path = ARGV[0]
output_path ||= "."

list_file = [ ARGV[2] ] if(ARGV[2])
list_file ||= [ "http://www.nietzschesource.org/exportToTalia.php?getList=all", { :http_basic_authentication => ["nietzsche", "source"] } ]


dl = HyperDownload::Downloader.new(output_path)
# Set the file mode if there is one
dl.file_mode = ARGV[1] if(ARGV[1])

xml_doc = nil

open(*list_file) do |io|
  xml_doc = REXML::Document.new(io.read)
end

puts "Fetching #{xml_doc.root.elements.size} elements"

progress = ProgressBar.new("Downloading", xml_doc.root.elements.size)

xml_doc.root.elements.each("siglum") do |element|
  progress.inc
  dl.grab_siglum(element.text.strip)
end

progress.finish
  