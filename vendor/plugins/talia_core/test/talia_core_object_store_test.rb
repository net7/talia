require 'test/unit'

# Test the Talia core "object store" classes
# TODO: These tests are based on loose specs so far
# FIXME: This includes dummy tests for REST services,
#       not sure how they can be simulated
# FIXME: Types need to use namespaces
class TaliaStoreTest < Test::Unit::TestCase
  
  # Creates the objects
  def setup
    @store[:adam] =  TaliaCore::ObjectStore.new(
      :uri => "http://www.local.com/adam",
      :storage => :local,
      :source_type => SourceType::Person
    )
    @store[:eve] =  TaliaCore::ObjectStore.new(
      :uri => "http://www.local.com/eve",
      :storage => :local,
      :source_type => SourceType::Person,
      :source_type => SourceType::Character
    )
    @store[:bob] =  TaliaCore::ObjectStore.new(
      :uri => "http://www.local.com/bob",
      :storage => :remote
    )
    @store[:alive] =  TaliaCore::ObjectStore.new(
      :uri => "http://www.alive.com/bob",
      :storage => :remote
    )
    @store[:invalid] =  TaliaCore::ObjectStore.new(
      :uri => "http://www.invalid.com/bob",
      :storage => :remote
    )
    
    for store in @store
      store.save
    end
  end
  
  # Tears everything down
  def teardown
  end
  
  # Tests the storage creation
  def test_create_store
    local_store = TaliaCore::ObjectStore.new(
      :uri => "http://www.local.com/myid",  # URL of the stored object
      :storage => :local,              # local store
      :source_type => SourceType::Essay
    )
    # TODO: Check handling for multiple source types
    assert_equal("essay", local_store.source_type)
    assert_equal("http://www.local.com/myid", local_store.uri)
    assert(!local_store.remote)
    
    remote_store = TaliaCore::ObjectStore.new(
      :uri => "http://www.remote.com/someid",
      :storage => :remote
    )
    assert_equal("remote_source", remote_store.source_type) # special reserved type
    # TODO: Check for remote source
    assert(remote_store.remote)
    
    # Should raise because not type is given for local source
    assert_raise(ObjectStoreError,
      TaliaCore::ObjectStore.new(
        :uri => "http://www.local.com/myid",  # URL of the stored object
        :storage => :local
      )
    )
      
    # Should raise because type is given for remote source
    assert_raise(
      TaliaCore::ObjectStore.new(
        :uri => "http://www.remote.com/myid",  # URL of the stored object
        :storage => :remote,              # local store
        :source_type => SourceType::Essay
      )
    )
  end
  
  # Test load and save. This also checks the handling of local
  # properties (name, in this case)
  def test_load_save
    local_store = TaliaCore::ObjectStore.new(
      :uri => "http://www.local.com/myid",  # URL of the stored object
      :storage => :local,              # local store
      :source_type => SourceType::Essay
    )
    local_store.name = "My essay"
    local_store.save
    
    remote_store = TaliaCore::ObjectStore.new(
      :uri => "http://www.remote.com/someid",
      :storage => :remote
    )
    remote_store.name = "Stranger in Paradise"
    remote_store.save
    
    assert(TaliaCore::ObjectStore.exists?("http://www.local.com/myid"))
    # Negative check
    assert(!TaliaCore::ObjectStore.exists?("http://www.local.com/noexist"))
    assert_equal(
      local_found = TaliaCore::ObjectStore.find("http://www.local.com/myid"),
      local_store
    )
    
    assert(TaliaCore::ObjectStore.exists?("http://www.remote.com/someid"))
    assert_equal(
      remote_found = TaliaCore::ObjectStore.find("http://www.remote.com/someid"),
      remote_store
    )
  end
  
  # Tests a source with multiple types
  def test_multitype
    local_store = TaliaCore::ObjectStore.new(
      :uri => "http://www.local.com/myid",  # URL of the stored object
      :storage => :local,              # local store
      :source_type => SourceType::Essay,
      :source_type => SourceType::CentralThought
    )
    assert_equal(2, local_store.type.count)
    local_store.save
    assert_equal(2, TaliaCore::ObjectStore.find("http://www.local.com/myid").type.count)
  end
  
  # Test the hash/signature
  def test_integrity_hash
    # TODO: Not spec'd yet
    # TODO: The hash will also have to go through the data objects
    # assert_equal(adam_hash, @sources[:adam].hashval)
    # assert_equal(bob_hash, @sources[:bob].source_hash) # Returns the locally stored hash
    # assert_equal(bob_remote_hash, @sources[:bob].remote_hash)
  end
  
  # Test remote source REST
  # TODO: How to test this?
  def test_remote_connection
    assert_equal(:no_connection, @sources[:bob].remote_state)
    assert_equal(:invalid, @sources[:invalid].remote_state)
    assert_equal(:alive, @sources[:alive].remote_state)
  end
  
  # Remote type fetching
  def test_remote_type_fetch
    assert_equal("remotebook", @sources[:alive].remote_type)
  end
  
  # Fetch remote property
  def test_remote_property
    assert_equal("#nil#", @source[:alive].remote_property("noexist"))
    assert_equal("golden", @source[:alive].remote_propert("color"))
    assert_raise(ObjectStoreError, @source[:invalid].remote_property("something"))
    assert_raise(ObjectStoreError, @source[:bob].remote_property("something"))
  end
  
  # "Set" property on a remote store. This should
  # initiate the Federation protocol and ask the remote host
  # to accept the relation into it's store
  # TODO: Not complete yet
  def test_remote_property_write
    # FIXME: The relation types need namespace handling
    @source[:bob].remote_property(RelationType::age, "23")
    @source[:bob].remote_property(RelationType::friend, @source[:adam])
    # You should ask someone to add a relation between two foreign objects
    assert_raise(ObjectStoreError, @source[:bob].remote_property(RelationType::friend, @source[:alive]))
    # save() tries to active the protocol
    # Does not succeed, because there is no connection
    assert_raise(ObjectStoreError, @source[:bob].save)
    
    @source[:alive].remote_property(RelationType::age, "23")
    @source[:alive].remote_property(RelationType::friend, @source[:adam])
    assert(@source[:alive].save)
  end
  
  # Test the find methods
  def test_find
    assert_equal(2, TaliaCore::ObjectStore.find(:type => SourceType::Person).count)
    assert_equal(@sources[:eve], TaliaCore::ObjectStore.find(:type => SourceType::Character)[0])
  end
  
  # Tests the equality check
  def test_equal
    # TODO: Write test for equal. It should compare all attributes
  end
  
end