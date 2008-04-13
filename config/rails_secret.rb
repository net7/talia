require 'digest/md5'

# Helper class to create secret (for session cookies, etc). This is used
# in order not to provide the secret with the "standard" file, where people
# will never change it and remain insecure.
# 
# This will write to a standard file in the local directory, it must be made
# sure that this file cannot be retrieved by users.
class RailsSecret
  
  SECRET_FILE = File.join(File.dirname(__FILE__), 'rails_secret')
  
  # Loads the secret from the file. Can autocreate a new secret if none 
  # exists
  def self.load_secret(autocreate = true)
    secret = nil
    if(File.exists?(SECRET_FILE))
      secret = File.open(SECRET_FILE) { |f| f.read  }
    elsif(autocreate)
      secret = create_secret
    end
    
    raise(ArgumentError, "No secret could be loaded!") unless(secret && secret.strip != '')
    secret
  end
  
  # Creates a new secret, overwriting the old one if it exists.
  # *Note*: The random generation may not be crypto-secure.
  #
  # However this will still be better than a predefined secret that is not
  # changed. 
  def self.create_secret
    secret = make_secret
    File.open(SECRET_FILE, File::WRONLY|File::TRUNC|File::CREAT, 0600) do |file|
      file.write(secret)
    end
    secret
  end
  
  private
  
  # Creates a pseudorandom secret. This is stolen (and slightly modified) from
  # the Rails implementation, it may not be fully crypto-secure
  def self.make_secret
    md5 = Digest::MD5.new
    now = Time::now
    md5.update(now.to_s)
    md5.update(String(rand(now.usec)))
    md5.update(String(rand(md5.hexdigest.to_i(16))))
    md5.update(String($$))
    md5.update('foobar')
    secret = md5.hexdigest
    md5.update(String(rand(md5.hexdigest.to_i(16))))
    secret << md5.hexdigest
    secret
  end
  
end
