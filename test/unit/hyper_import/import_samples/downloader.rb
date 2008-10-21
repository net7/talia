#!/usr/bin/ruby
$: << File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'lib')
require 'talia_util/hyper_download'

unless(ARGV[0])
  puts "Usage downloader.rb <list_file> [output_path (default .)]"
  exit 1
end

output_path = ARGV[1]
output_path ||= "."

dl = HyperDownload::Downloader.new(output_path)

xml_doc = REXML::Document.new
xml_doc.add_element("sigla")

open(ARGV[0]) do |file|
  file.each_line do |line|
    line.strip!
    unless(line == "" || line.include?(":"))
      puts "fetching #{line}"
      dl.grab_siglum(line)
      el = xml_doc.root.add_element("siglum")
      el.add_text("#{line}.xml")
    end
  end
end

File.open(File.join(output_path, "list.xml"), "w") do |file|
  xml_doc.write(file)
end
