require 'oai'

module TaliaCore
  module Oai
    
    class ActiveSourceWrapper < OAI::Provider::Model
      
      def initialize
        @timestamp_field = "timestamp"
        # These are the classes that are used
        @active_classes = [ :book, :facsimile ]
      end
      
      def earliest
        select_first_or_last('asc')
      end
      
      def latest
        select_first_or_last('desc')
      end
      
      def sets
        raise(OAI::SetException, "Sets not yet supported") # TODO: Support sets
      end
      
      def find(selector, options = {})
        raise(OAI::ResumptionTokenException, "Resumption not yet implemented")  if options[:resumption_token] # TODO: Support resumption
        ActiveSource.find(selector, :conditions => sql_conditions(options)).collect { |rec| TaliaCore::Oai::ActiveSourceOaiAdapter.get_wrapper_for(rec) }
      end
      
      private
      
      def select_first_or_last(order)       
        TaliaCore::ActiveSource.find(:first, :select => 'created_at', :order => "created_at #{order}").created_at
      end
      
      # build a sql conditions statement from an OAI options hash
      def sql_conditions(opts)
        from = Time.parse(opts[:from].to_s).localtime
        untl = Time.parse(opts[:until].to_s).localtime
        sql = ['created_at >= ? AND created_at <= ?', from, untl]
        
        add_class_fragment_to(sql)
        
        return sql
      end
      
      
      def add_class_fragment_to(sql)
        frag = ''
        vars = []
        @active_classes.each do |klass|
          if(klass == @active_classes.first)
            frag << 'type = ?'
          else
            frag << ' OR type = ?'
          end
          vars << klass.to_s.camelize
        end
        sql_add_fragment_to(sql, frag, *vars)
      end
      
      # Adds the given fragment to the sql string and adds the vars to the
      # variables that are present for the sql. The old_fragment ist an array
      # with an SQL string template and following variables, as used by 
      # ActiveRecord
      def sql_add_fragment_to(old_fragment, new_frag, *vars)
        old_fragment[0] << ' AND ('
        old_fragment[0] << new_frag
        old_fragment[0] << ')'
        old_fragment.concat(vars)
      end
      
    end
    
  end
end
