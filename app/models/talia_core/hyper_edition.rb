module TaliaCore
  
  # Refers to what was called an "Edition" in the original Hyper. This is *not*
  # an edition in the sense of the FacsimileEdition or CriticalEdition
  class HyperEdition < Manifestation
    
    def to_html
      assit_fail("Should never call base class version of to_html.")
      # to be overridden by subclasses
    end
  end
end
