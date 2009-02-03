module UriEncoder
  extend self

  def escape(string)
    CGI::escape string
  end
  
  def unescape(string)
    CGI::unescape string
  end
  
  def normalize_uri(uri)
    uri = unescape(uri.to_s).strip.gsub(/\s\s/, '').gsub(' ', '+').gsub(/[^\w\d\(\)\'\+]/, '')
    uri.gsub(/\b([a-z])/i) { $1.capitalize } # titleize
  end
  
  def unescape_link(link)
    unescape(link).gsub(' ', '+')
  end
end
