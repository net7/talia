#!/usr/bin/env ruby
# -*- Ruby -*-
# 
#   irb.rb - intaractive ruby
#   	$Release Version: 0.9.5 $
#   	$Revision: 11708 $
#   	$Date: 2007-02-13 08:01:19 +0900 (Tue, 13 Feb 2007) $
#   	by Keiju ISHITSUKA(keiju@ruby-lang.org)
#
$: << File.expand_path(File.dirname(__FILE__))
$: << File.join(File.dirname(__FILE__), '..', 'lib') # For Talia core

require "talia_commands"
require "talia_core"
require "command_line"
require "talia_util"
require "irb"
require "rake"

include TaliaUtil
title

puts "\nEnter <chelp> for help on the Talia-specific commands."
puts ""

flags = TaliaCommands::flags

unless(flags.noinit?)
  init_talia
  talia_config if(flags.verbose?)
else
  puts "Talia not initialized, as requested."
end

if __FILE__ == $0
  IRB.start(__FILE__)
else
  # check -e option
  if /^-e$/ =~ $0
    IRB.start(__FILE__)
  else
    IRB.setup(__FILE__)
  end
end
