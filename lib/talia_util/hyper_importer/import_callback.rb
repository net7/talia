module TaliaUtil
  module HyperImporter
    
    class ImportCallback
      
      include TaliaUtil::Progressable
      
      def after_import
        run_with_progress("Ordering Elements", TaliaUtil::OrderUtil.to_order_count) do |progress|
          TaliaUtil::OrderUtil.order_all { progress.inc }
        end
      end
      
    end
  end
end