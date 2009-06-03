require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'
require 'fileutils'

module TaliaCore
  
  module UnitTestHelpers
    
    def klass_name
      self.class.to_s.gsub(/:+/, '_')
    end
    
    # Set up the IIP directory
    def setup_iip
      TaliaCore::CONFIG["iip_root_directory_location"] = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'fixtures', 'iip_test_data')
      clean_iip
    end
    
    # Clean out the IIP directory
    def clean_iip
      iip_dir = TaliaCore::CONFIG["iip_root_directory_location"]
      FileUtils.rm_rf(iip_dir) if(File.exists?(iip_dir))
    end
    
    # Creates a dummy expression card
    def make_card(name, save = true, klass = ExpressionCard)
      kname = klass_name
      kname += klass.name.underscore unless(klass == ExpressionCard)
      card = klass.new("http://#{kname}/#{name}")
      card.save! if(save)
      card
    end
    
    # Creates a dummy book with a number of pages
    def make_book(name, page_count = 0)
      book = make_card(name, true, Book)
      book.save!
      page_count.times do |n|
        page = make_card("#{name}_page_#{n}", true, Page)
        page.dct::isPartOf << book
        page.save!
      end
      book
    end

     # Make a chapter
    def make_chapter(name)
      chapter = Chapter.new("http://#{klass_name}/#{name}")
      chapter.save!
      chapter      
    end
    
    # Make a paragraph
    def make_paragraph(name)
      paragraph = Paragraph.new("http://#{klass_name}/#{name}")
      paragraph.save!
      paragraph      
    end

    # Make a note
    def make_note(name)
      note = Note.new("http://#{klass_name}/#{name}")
      note.save!
      note     
    end

    # Make a page
    def make_page(name)
      page = Page.new("http://#{klass_name}/#{name}")
      page.save!
      page     
    end

    
    # Make a text reconstruction
    def make_text_reconstruction(name)
      text_reconstruction = TextReconstruction.new("http://#{klass_name}/#{name}")
      text_reconstruction.save!
      text_reconstruction.types << N::HYPER.TextReconstruction
      text_reconstruction.types << N::HYPER.HyperEdition
      text_reconstruction.save!
      text_reconstruction
    end

    # Make an transcription
    def make_transcription(name)
      transcription = Transcription.new("http://#{klass_name}/#{name}")
      transcription.save!
      transcription.types << N::HYPER.Transcription
      transcription.types << N::HYPER.HyperEdition
      transcription.save!
      transcription
    end
    
    # Make a catalog
    def make_catalog(name)
      make_card(name, true, Catalog)
    end
    
    # Make a book with 5 pages, 2 chapters and 7 paragraphs.
    # Each other page has two paragraphs, the even ones have one paragrahs each.
    # Chapters start on the first and on the fourth page.
    def make_big_book(name)
      book = make_book(name)
      book.save!
      5.times do |i|
        page = make_page("#{name}-page#{i}")
        page.save!        
        page.types << N::HYPER.Page
        page.dct::isPartOf << book
        page.position = "%06d" % (i + 1)
        page.save!
        note1 = make_note("#{name}-page#{i}-paragraph1-note1")
        note1.save!
        note1.types << N::HYPER.Note
        note1.position = '000001'
        note1.siglum = "#{name}-page#{i}-paragraph1-note1"
        note1.hyper::page << page
        note1.save!
        paragraph1 = make_paragraph("#{name}-page#{i}-paragraph1")
        paragraph1.save!
        paragraph1.types << N::HYPER.Paragraph
        paragraph1.siglum = "#{name}-page#{i}-paragraph1"
        paragraph1.hyper::note << note1
        paragraph1.save!
        if i.odd?
          note2 = make_note("#{name}-page#{i}-paragraph2-note1")
          note2.save!
          note2.types << N::HYPER.Note
          note2.position = '000002'
          note2.siglum = "#{name}-page#{i}-paragraph2-note1"
          note2.hyper::page << page
          note2.save!
          paragraph2 = make_paragraph("#{name}-page#{i}-paragraph2")
          paragraph2.save!
          paragraph2.types << N::HYPER.Paragraph
          paragraph2.siglum = "#{name}-page#{i}-paragraph2"
          paragraph2.hyper::note << note2
          paragraph2.save!
        end
        if i == 0
          chapter1 = make_chapter("#{name}-chapter1")
          chapter1.save!
          chapter1.types << N::HYPER.Chapter
          chapter1.book = book
          chapter1.first_page = page
          chapter1.save!
        end
        if i == 3
          chapter2 = make_chapter("#{name}-chapter2")
          chapter2.save!          
          chapter2.types << N::HYPER.Chapter
          chapter2.book = book
          chapter2.first_page = page
          chapter2.save!          
        end
      end
      book
    end
    
    def make_big_book_with_text_reconstructions(name)
      book = make_big_book(name)
      book.pages.each do |page|
        text_reconstruction = make_text_reconstruction("#{page.uri.local_name}-text_reconstruction")
        quick_add_property(text_reconstruction, N::HYPER.manifestation_of, page)
        text_reconstruction.save!
      end
      book.paragraphs.each do |paragraph|
        text_reconstruction = make_text_reconstruction("#{paragraph.uri.local_name}-text_reconstruction")
        quick_add_property(text_reconstruction, N::HYPER.manifestation_of, paragraph)
        text_reconstruction.save!
      end
      book
    end
    
   # Quick hack to "quickly" add a new property to the given Source. This
  # will bypass the usual rdf creation routines and simply add the new
  # property both to the db and rdf "manually" (which is quicker than recreating
  # the rdf fully.
  def quick_add_property(subject, predicate, object)
    autosave = subject.autosave_rdf?
    subject.autosave_rdf = false if(autosave)
    subject[predicate] << object
    subject.save!
    subject.my_rdf[predicate] << object
    subject.my_rdf.save
    subject.autosave_rdf = autosave
  end
    # Get the class that is tested here
    def tested_klass
      return @tested_klass if(@tested_klass)
      name = self.class.name.demodulize.gsub(/Test$/, '')
      klass = nil
      begin
        klass = TaliaCore.const_get(name)
      rescue
        klass = nil
      end
      @tested_klass = klass
    end 
    
    # Runs an automatic test on the cloning if the class supports it
    def test_cloning_autotest
      can_clone = (tested_klass && tested_klass.respond_to?(:props_to_clone))
      return unless(can_clone)
      can_clone &= (tested_klass.props_to_clone.size > 0)
      clone_props = self.class.test_clone_properties
      assert(!clone_props || can_clone, "Cloning not possible on #{tested_klass.name}")
      auto_clone_test(tested_klass)
      assert_cloned(tested_klass, *clone_props) if(clone_props)
    end
    
    # Automatically tests if all the configured properties for this class are
    # cloned.
    def auto_clone_test(klass)
      assert(klass.props_to_clone.size > 0)
      orig = klass.new("http://#{klass_name}/clone_tester")
      klass.props_to_clone.each do |prop|
        orig[prop] << prop_for_clone(prop)
      end
      orig.save!
      clone = orig.clone(orig.uri + 'clone')
      clone.save!
      klass.props_to_clone.each do |prop|
        assert_property(clone[prop], *orig[prop])
        expected = prop_for_clone(prop)
        assert(clone[prop].include?(expected))
      end
    end

    def prop_for_clone(prop)
      value = "#{prop} the value"
      (prop == N::RDF.type) ? N::SourceClass.new(value) : value
    end

    # Asserts if the given properties are cloned on this class
    def assert_cloned(klass, *properties)
      properties.each do |prop|
        assert(klass.props_to_clone.include?(prop), "The #{prop} property is not cloned")
      end
    end
    
  end
  
end

# Add some stuff to the basic test case
class Test::Unit::TestCase
  
  def self.test_clone_properties
    @test_cloning
  end
  
  # Can be used to force a test for cloning on ExpressionCards. 
  # You may optinally give a list of properties that must be cloned.
  def self.test_cloning(*properties)
    @test_cloning = properties
  end
end
