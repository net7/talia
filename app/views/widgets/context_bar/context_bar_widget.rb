class ContextBarWidget < Widgeon::Widget
  
  def before_render
    return unless(@source) # Just bail out if no source is given
    sassert_not_nil(@properties, "Must use context bar with properties.")
    @context_groups = {}
    if(@source)
      @source.direct_predicates.each do |pred|
        # Find out if the propety is configured
        if(get_property(pred))
          add_to_groups(:normal, pred)
        end
      end
      @source.inverse_predicates.each do |pred|
        add_to_groups(:inverse, pred)
      end
    end
  end
  
  # Cycle through all the groups. This is a helper to be used in the
  # widget template. Give a block to this method: The first parameter will
  # be set to the group header, and the second will contain the list of 
  # elements for the group.
  def each_group(&block)
    return unless(@source) # Bail out if we have no source
    @context_groups.each do |group, contents|
      property = get_property(group)
      if(property) # Just do this for the configured elements
        contents[:inverse] = [] unless(contents[:inverse])
        contents[:normal] = [] unless(contents[:normal])
        if(property['is_symmetric']) # Check if this is a symmetric predicate
          all_contents = contents[:normal]
          # Add all the predicate values of the normal and the inverse
          # list together
          contents[:inverse].each { |inv| all_contents << inv }
          block.call(property['label'], all_contents) if(contents.size > 0)
        else
          # First call for the normal predicates
          block.call(property['label'], contents[:normal]) if(contents[:normal].size > 0)
          # Then do it for the inverse predicates
          block.call(property['inv_label'], contents[:inverse]) if(contents[:inverse].size > 0)
        end
      end
    end
    "" # This helper should not return anything
  end
  
  protected
  
  # Reads the property from the given URI (must give a URI object)
  def get_property(uri)
    @properties["#{uri.namespace}##{uri.local_name}"]
  end
  
    # Adds the given predicate to the groups as normal or inverse predicate.
  # The resulting context_groups hash has the following structure for each element:
  # predicate_xxx => {:inverse => [predicates], :normal => [predicates] }
  # The key is the predicate object, while the  predicates in the (inverse|normal)
  # are the sources referenced by the (normal or inversed) predicate.
  def add_to_groups(type, predicate)
    predicates = (type == :inverse) ? @source.inverse[predicate] : @source[predicate]
    predicates = predicates.find_all { |pred| pred.kind_of?(TaliaCore::Source) }
    if(predicates.size > 0)
      @context_groups[predicate] = {} unless(@context_groups[predicate])
      @context_groups[predicate][type] = predicates 
    end
  end
  
end
