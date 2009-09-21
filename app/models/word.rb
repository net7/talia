require 'rexml/document'

class Word < ActiveRecord::Base
  
  # add all words
  def self.add_contribution(uri)

    # check if uri is null
    raise "uri argument cannot be null" if uri.nil?

    # get contribution
    contribution = TaliaCore::Source.find(uri)

    # check if contribution is present
    raise "contribution not found" if contribution.nil?

    # get HTML version of contribution
    content_version = contribution.available_versions[0]
    content = contribution.to_html(content_version )

    # get contribution content
    doc = REXML::Document.new content
    doc_content = doc.elements.each("//text()")

    doc_content.each do |item|

      value = item.value.strip

      unless value == ""

        value.split(/[\s[:punct:]]/).each do |word|
          self.add_word word unless word == ""
        end

      end

    end

  end


  # add a new word or increment the counter if it is already present.
  def self.add_word(word)

    # check if word is null
    raise "word argument cannot be null" if word.nil?
  
    # find word record
    word_record = self.find(:first, :conditions => {:word => word})

    if(word_record.nil?)
      # if word is not present, add it (counter will be equal to 1)
      self.create!(:word => word)
    else
      # if word is present, increment counter value
      word_record.counter = word_record.counter + 1
      word_record.save!
    end

  end

  

end
