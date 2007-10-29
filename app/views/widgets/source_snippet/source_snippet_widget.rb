class SourceSnippetWidget < Widgeon::Widget
  
  @@type_templates = {
    N::TALIADOM + 'Book' => 'book',
    N::FOAF + 'Person' => 'person',
    N::TALIADOM + 'FictionalPerson' => 'fictional_person',
    N::FOAF + 'Group' => 'group',
    N::TALIADOM + 'FictionalPlace' => 'fictional_place',
    N::TALIADOM + 'AbstractConcept' => 'abstract_concept',
    N::TALIADOM + 'GraphicNovel' => 'graphic_novel'
  }
  
  # Kludge to avoid problems with changing sequence on Hash#keys
  @@template_keys = @@type_templates.keys
  
  
  def before_render
  end
  
  
  # Return the correct partial sub-template for the given Source, depending 
  # on the source type. If not template is found, return 'default't
  def get_item_template(source)
    types = source.types
    
    # Select the first matching template
    key = @@template_keys.detect { |type| types.include?(type) }
    key ? @@type_templates[key] : 'default'
  end
end
