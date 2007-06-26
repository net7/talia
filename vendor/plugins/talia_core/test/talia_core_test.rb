require 'test/unit'

# Test the Talia core classes
# TODO: These tests are based on loose specs so far
class TaliaCoreTest < Test::Unit::TestCase

  # Create the local stuff
  def setup
    # TODO: Namespace etc. not yet finalized
    Namespace::Base.register("remote", "http://www.remote.com/")
    Namespace::Base.register("local", "http://www.local.com/")
    TaliaCore::Base.local_namespace = Namespace::Local
    SourceType::Base.register("essay", Namespace::Local::Essay)
    SourceType::Base.register("person", "http://www.foaf2.org/something/person")
    
    # Since there are no fixtures for this, create a few objects for
    # the tests
    @sources = Hashtable.new
    @sources[:adam] = TaliaCore::Source.new("adam", SourceType::Person)
    @sources[:adam].save
    @sources[:eve] = TaliaCore::Source.new("eve", SourceType::Person)
    @sources[:eve].save
    @sources[:snake] = TaliaCore::Source.new("snake", SourceType::Person)
    @sources[:snake].save
    @sources[:about_sin] = TaliaCore::Source.new("about_sin", SourceType::Essay)
  end

  # TODO: Teardown missing

  # Test the creation of a local source
  def test_local_creation
    local_source = TaliaCore::Source.new("id-string", SourceType::Person)
    assert(!local_source.remote?)
    assert_equal("id-string", local_source.identifier)
    assert_equal(SourceType::Person, local_source.types[0])
    # Check for duplicate
    # TODO: This should really fail if the object is not yet saved, but how to do it?
    assert_raises(TaliaError, TaliaCore::Source.new("id-string", SourceType::Person))
    
    local_source_2 = TaliaCore::Source.new(Namespace::Local::idstring2, SourceType::Person, SourceType::Essay)
    assert(local_source_2.local?)
    assert_equal(2, local_source_2.types.count)
    
    local_source_3 = TaliaCore::Source.new("http://www.local.com/myid3")
    assert(!local_source_3.remote)
    assert_equal("myid3", local_source_3.identifier)
  end
  
  # Creating remote sources
  def test_remote_creation
    # TODO: Remote source will be unreachable. Behaviour?
    remote_source = TaliaCore::Source.new(Namespace::Remote::remote_id)
    assert(remote_source.remote)
    assert_equal("remote_id", remote_source.indentifier)
    
    remote_source_2 = TaliaCore::Source.new("http://faraway.org/something/else_id")
    assert(remote_source_2.remote)
    assert_equal("else_id", remote_source_2.identifier)
  end
  
  # Test relation setting and getting
  def test_relations
    assert_nil(@sources[:eve].friend)
    @sources[:eve].friend = @sources[:adam]
    assert_equal(@sources[:eve].friend, @sources[:adam])
    # The reverse will only work after saving
    # TODO: May change
    assert_nil(@sources[:adam].friend_of)
    @sources[:eve].save
    assert_equal(@sources[:eve], @sources[:adam].friend_of)
    
    @sources[:eve].friend = @sources[:snake]
    assert_equal(2, @sources[:eve].friend.count)
    
    assert_equal("friend", @sources[:eve].relations[0])
  end
  
  # Test property setting and getting
  def test_properties
    assert_nil(@sources[:eve].apple)
    @sources[:eve].apple = "green"
    assert_equal("green", @sources[:eve].apple)
    assert_equal("apple", @sources[:eve].properties[0])
    
    # TODO: What about when we try to assign this as a relation now?
  end
  
  # Test saving 
  def test_save
    my_source = TaliaCore::Source.new("myself", SourceType::Person)
    your_source = TaliaCore::Source.new("yourself", SourceType::Person)
    
    my_source.friend = your_source
    assert(!TaliaCore::Source.exists?("myself"))
    
    # Tricky case: Both sources should be saved, or there could be 
    # a dangling relation
    assert(my_source.save)
    assert(TaliaCore::Source.exists?("myself"))
    assert(TaliaCore::Source.exists?("yourself"))
  end
  
  
end
