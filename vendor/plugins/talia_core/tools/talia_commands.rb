# Create the commands for the Talia console
require 'console_commands'

desc "Show help on the talia console commands"
command(:chelp) do
  puts "Talia console commands:\n\n"
  @commands.each do |command|
    puts "#{command[0]}\t- #{command[1]}"
  end
 nil
end

desc "Print all source URIs"
command(:sources) do
  TaliaCore::Source.find(:all).each do |source|
    puts source.uri
  end
  nil
end

desc "Find a source by local uri"
command(:src) do |uri|
  TaliaCore::Source.find(N::LOCAL + uri)
end
