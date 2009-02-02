require 'iconv'

module Ascii
  def escape_accented_entities
    escape_entities :accented
  end

  def to_ascii
    escape_entities :unaccented
  end

  def to_url_format
    url_format = self.to_ascii
    url_format = url_format.gsub(/[^A-Za-z0-9]/, '') # all non-word
    url_format.downcase!
    url_format
  end

  protected
    def escape_entities(type)
      # split in muti-byte aware fashion and translate characters over 127
      # and dropping characters not in the translation hash
      entities = send("#{type}_entities")
      self.chars.split('').collect { |c| (c[0] <= 127) ? c : entities[c[0]] }.join
    end
  
    def unaccented_entities
      @@translation_hash ||= begin
        accented_chars   = "ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝàáâãäåçèéêëìíîïñòóôõöøùúûüý".chars.split('')
        unaccented_chars = "AAAAAACEEEEIIIIDNOOOOOxOUUUUYaaaaaaceeeeiiiinoooooouuuuy".split('')

        translation_hash = {}
        accented_chars.each_with_index { |char, idx| translation_hash[char[0]] = unaccented_chars[idx] }
        translation_hash["Æ".chars[0]] = 'AE'
        translation_hash["æ".chars[0]] = 'ae'
        translation_hash
      end
    end
    
    def accented_entities
      @@accented_entities ||= begin
        accented_chars = "ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ".chars.split('')
        escaped_accented_chars = ((192..214).to_a + (216..246).to_a + (248..255).to_a).map { |i| "&##{i};"}
      
        returning result = {} do
          accented_chars.each_with_index { |c, i| result[c[0]] = escaped_accented_chars[i] }
          result
        end
      end
    end
end