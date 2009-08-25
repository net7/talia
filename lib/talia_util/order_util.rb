module TaliaUtil

  # Helper methods to order book and chapter pages and such
  class OrderUtil
    class << self

      # Get the number of elements to order
      def to_order_count
        TaliaCore::Book.count + TaliaCore::Chapter.count
      end

      # Order all chapters and books in the system. You can pass a block
      # that will be called on each ordering with the given element
      def order_all
        TaliaCore::Book.find(:all).each do |book|
          book.order_pages!
          yield book if(block_given?)
        end
        TaliaCore::Chapter.find(:all).each do |chapter|
          chapter.order_pages!
          yield chapter if(block_given?)
        end
      end

    end
  end

end