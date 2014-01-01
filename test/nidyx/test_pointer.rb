require "minitest/autorun"
require "nidyx/pointer"

class TestPointer < Minitest::Test
  def test_full_pointer
    ptr = Nidyx::Pointer.new("http://url.com#path/to")
    assert(ptr.source == "http://url.com")
    assert(ptr.path == ["path", "to"])
  end

  def test_source_only_pointer
    ptr = Nidyx::Pointer.new("http://url.com#")
    assert(ptr.source == "http://url.com")
    assert(ptr.path == [])
  end

  def test_path_only_pointer
    ptr = Nidyx::Pointer.new("#path/to")
    assert(ptr.source == "")
    assert(ptr.path == ["path", "to"])
  end

  def test_empty_pointer
    ptr = Nidyx::Pointer.new("#")
    assert(ptr.source == "")
    assert(ptr.path == [])
  end
end
