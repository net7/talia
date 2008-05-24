class WizardModelForXhtml < WizardModel
  
  wizard_name "xhtml_wizard"
  wizard_title "XHTML Wizard Form"
  
  step "Document data", "step_one" do
    validates_presence_of :author
    validates_presence_of :title
  end
  
  step "File","step_two" do
    validates_presence_of :file
    validates_presence_of :file_original_filename
    validates_inclusion_of :file_content_type, :in => ["text/xml"], :message => " %s is not included in the list"
  end
  
end
