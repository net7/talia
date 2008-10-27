# Common code for all simple edition controllers
class SimpleEditionController < ApplicationController
  layout 'simple_edition'
  
  before_filter :find_edition
  before_filter :set_edition_type
  before_filter :set_custom_stylesheet
  before_filter :set_print_stylesheet
  before_filter :set_javascripts
  
  private
  
  def edition_class
    @edition_class ||= "TaliaCore::#{self.class.edition_type.to_s.camelize}Edition".constantize
  end
  
  def edition_prefix
    @edition_prefix ||= edition_class::EDITION_PREFIX
  end
  
  def find_edition
    @edition = edition_class.find("#{N::LOCAL}#{edition_prefix}/#{params[:id]}")
  end
  
  def set_edition_type
    @edition_type = self.class.edition_type
  end
  
  def set_custom_stylesheet(custom_stylesheet = nil)
    if custom_stylesheet.nil?
      @custom_stylesheet = self.class.custom_stylesheet
    else
      @custom_stylesheet = custom_stylesheet
    end
  end
  
  def set_print_stylesheet(print_stylesheet = nil)
    if print_stylesheet.nil?
      @print_stylesheet = self.class.print_stylesheet
    else
      @print_stylesheet = print_stylesheet
    end
  end

  def set_javascripts
    @javascripts = self.class.javascripts || []
  end
  
  def self.edition_type
    @edition_type
  end
  
  def self.custom_stylesheet
    @custom_stylesheet
  end
  
  def self.print_stylesheet
    @print_styleshee
  end
  
  def self.javascripts
    @javascripts
  end
  
  # Used to set the edition type
  def self.set_edition_type(type)
    @edition_type = type
  end

  # Set custom stylesheet for single action
  def self.set_custom_stylesheet(custom_stylesheet)
    @custom_stylesheet = custom_stylesheet
  end
  
  # Set custom stylesheet for single action
  def self.set_print_stylesheet(print_stylesheet)
    @print_stylesheet = print_stylesheet
  end
  
  # Set additional javascripts
  def self.add_javascripts(*scripts)
    @javascripts ||= []
    scripts.each { |s| @javascripts << s }
  end
  
end
