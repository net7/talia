class SimpleModeController < ApplicationController

  def testing_def
    
    @path = [{:text => 'DEF'}]
    @displayButtons = false
    render :template => "simple_mode/facsimile_edition/index", :layout => "facsimile_edition"
    
  end
  
  def material_list
    @path = [
      {:text => 'DEF', :controller => 'simple_mode', :action => 'testing_def'},
      {:text => 'manoscritto'}
    ]
    @displayButtons = true
  
    @tabs_elements = [
      {:text => 'N-IV-1', :selected => false},
      {:text => 'N-IV-2', :selected => true}
    ]
    
    render :template => "simple_mode/facsimile_edition/material_list", :layout => "facsimile_edition"
    
  end
  
  def panorama
    @path = [
      {:text => 'DEF', :controller => 'simple_mode', :action => 'testing_def'},
      {:text => 'manoscritto', :controller => 'simple_mode', :action => 'material_list'},
      {:text => 'N-IV-1'}
    ]
    @displayButtons = true
    render :template => "simple_mode/facsimile_edition/panorama", :layout => "facsimile_edition"
   
  end
  
  def page_view
    @path = [
      {:text => 'DEF', :controller => 'simple_mode', :action => 'testing_def'},
      {:text => 'manoscritto', :controller => 'simple_mode', :action => 'material_list'},
      {:text => 'N-IV-1', :controller => 'simple_mode', :action => 'panorama'}
    ]
    @displayButtons = true
    render :template => "simple_mode/facsimile_edition/page_view", :layout => "facsimile_edition"
   
  end
  
  
end
