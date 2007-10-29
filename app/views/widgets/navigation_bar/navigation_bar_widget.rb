class NavigationBarWidget < Widgeon::Widget
  
  def before_render
    if(@source_class && @source_class != (N::RDFS + "Resource"))
      @supertypes = @source_class.supertypes
      @subtypes = @source_class.subtypes
    else
      @supertypes = []
      @subtypes = [
        N::SourceClass.new((N::TALIAS + 'Source').to_s),
        N::SourceClass.new((N::FOAF + 'Person').to_s)
      ]
    end
  end
end
