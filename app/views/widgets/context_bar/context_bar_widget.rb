class ContextBarWidget < Widgeon::Widget
  
  def before_render
    @context_groups = {}
    if(@source)
      @source.direct_predicates.each do |pred|
        unless((N::RDF::type == pred) || (N::TALIA_DB == pred.domain_part) || (N::LOCAL::type == pred))
          add_to_groups(:normal, pred)
        end
      end
      @source.inverse_predicates.each do |pred|
        add_to_groups(:inverse, pred)
      end
    end
  end
  
  protected
  
  # Adds the given predicate to the groups as normal or inverse predicate
  def add_to_groups(type, predicate)
    
    predicates = (type == :inverse) ? @source.inverse[predicate] : @source[predicate]
    predicates = predicates.find_all { |pred| pred.kind_of?(TaliaCore::Source) }
    if(predicates.size > 0)
      @context_groups[predicate] = {} unless(@context_groups[predicate])
      @context_groups[predicate][type] = predicates 
    end
  end
end
