# This file contains all the errors that can be raised in the 
# Talia core. Since these are not useful classes, they are grouped
# together in one file.
  
# Indicates that it was tried to create an object with
# an identifier (e.g. an URI) which already exists in the
# system.
class DuplicateIdentifierError < RuntimeError
end

# Indicates an error during initialization
class SystemInitializationError < RuntimeError
end

# Indicates an error with the predicate naming
class SemanticNamingError < RuntimeError
end

# Indicates an error in a query
class QueryError < RuntimeError
end