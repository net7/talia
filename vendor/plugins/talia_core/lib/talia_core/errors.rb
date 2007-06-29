# This file contains all the errors that can be raised in the 
# Talia core. Since these are not useful classes, they are grouped
# together in one file.
module TaliaCore
  
  # Indicates that it was tried to create an object with
  # an identifier (e.g. an URI) which already exists in the
  # system.
  class DuplicateIdentifierError < RuntimeError
  end
end