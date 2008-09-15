module TypesHelper
  def types_javascripts
    javascript :mainElementPositioning, :toolbar,
      :window_onresize_event, :window_onload_event, :text_onresize_event,
      :handleSearchField, :utilities
  end
  
  def types_stylesheets
    stylesheet :pod_style_navigation, :wizard
  end
end
