require 'oai'

module TaliaCore
  module Oai
    
    class ActiveSourceWrapper < OAI::Provider::Model
      
      def initialize
        @timestamp_field = "timestamp"
        # These are the classes that are used
        #@active_classes = [ :book, :facsimile, :bibliographical_card ]
        @active_classes = [:bibliographical_card ]
        @limit = nil
      end
      
      def earliest
        select_first_or_last('asc')
      end
      
      def latest
        select_first_or_last('desc')
      end
      
      def sets
        raise OAI::SetException # TODO: Support sets
      end
      
      def find(selector, options = {})
        return select_partial(options[:resumption_token]) if(options[:resumption_token])
        
        if(selector == :first)
          wrap(ActiveSource.find(selector, :conditions => sql_conditions(options)))
        elsif(selector == :all)
          select_partial(OAI::Provider::ResumptionToken.new(options.merge(:last => 0)))
        else
          wrap(ActiveSource.find(selector, :conditions => sql_conditions(options)))
        end
      rescue ActiveRecord::RecordNotFound
        nil
      end
      
      private
      
      # Selects a partial result set from a resumption token
      def select_partial(token)
        token = OAI::Provider::ResumptionToken.parse(token) if(token.is_a?(String))
        
        conditions = token_conditions(token)
        total = ActiveSource.count(:id, :conditions => conditions)
        
        return [] if(total == 0)
        
        if(@limit.nil?)
          records = ActiveSource.find(:all, :conditions => token_conditions(token),
            :order => 'id asc'
          )
	else
          records = ActiveSource.find(:all, :conditions => token_conditions(token),
            :limit => @limit,
            :order => 'id asc'
          )
	end
        raise(OAI::ResumptionTokenException) unless(records)
        
        if(!@limit.nil? and @limit < total)
          wrap(records)
        else
          last_id = records.last.id
          OAI::Provider::PartialResult.new(wrap(records), token.next(last_id))
        end
      end
      
      # Wraps the record(s) into an appropriate adapter wrapper
      def wrap(recs)
        if(recs == nil)
          nil
        elsif(recs.is_a?(ActiveSource))
          TaliaCore::Oai::ActiveSourceOaiAdapter.get_wrapper_for(recs)
        else
          recs.collect { |rec| TaliaCore::Oai::ActiveSourceOaiAdapter.get_wrapper_for(rec) }
        end
      end
      
      def select_first_or_last(order)       
        TaliaCore::ActiveSource.find(:first, :select => 'created_at', :order => "created_at #{order}").created_at
      end
      
      # Sql condition for the given token
      def token_conditions(token)
        sql = sql_conditions(token.to_conditions_hash)
        sql_add_fragment_to(sql, 'id > ?', token.last) if(token.last != 0)
        sql
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
