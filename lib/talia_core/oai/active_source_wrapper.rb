require 'oai'

module TaliaCore
  module Oai
    
    class ActiveSourceWrapper < OAI::Provider::Model
      
      def initialize
        
      end
      
      def earliest
        select_first_or_last('asc')
      end
      
      def earliest
        select_first_or_last('desc')
      end
      
      def sets
        raise(OAI::SetException, "Sets not yet supported") # TODO: Support sets
      end
      
      def find(selector, options = {})
        raise(OAI::ResumptionTokenExeption, "Resumption not yet implemented") # TODO: Support resumption
        records = ActiveSource.find(selector, :conditions => sql_conditions(options))
      end
      
      private
      
      def select_first_or_last(order)       
        TaliaCore::ActiveSource.find(:first, :select => 'updated_at', :order => "updated_at #{order}").updated_at
      end
      
      # build a sql conditions statement from an OAI options hash
      def sql_conditions(opts)
        from = Time.parse(opts[:from].to_s).localtime
        untl = Time.parse(opts[:until].to_s).localtime
        sql = ['updated_at >= ? AND updated_at <= ?', from, untl]
        
        return sql
      end
      
    end
    
  end
end
