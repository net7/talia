module TaliaCore
  module Oai
    
    class FacsimileAdapter < ActiveSourceOaiAdapter
      
      def type
        N::DCMIT.Image
      end
      
    end
    
  end
end

