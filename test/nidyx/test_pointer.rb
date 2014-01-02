require "minitest/autorun"
require "nidyx/pointer"

class TestPointer < Minitest::Test
  def test_basic_pointer
    ptr = Nidyx::Pointer.new("http://url.com#/path/to")
    assert_equal("http://url.com", ptr.source)
    assert_equal(["path", "to"], ptr.path)
  end

  def test_source_only_pointer
    ptr = Nidyx::Pointer.new("http://url.com#")
    assert_equal("http://url.com", ptr.source)
    assert_equal([], ptr.path)
  end

  def test_path_source_pointer
    ptr = Nidyx::Pointer.new("some/path/file.js#/definitions")
    assert_equal("some/path/file.js", ptr.source)
    assert_equal(["definitions"], ptr.path)
  end

  def test_path_only_pointer
    ptr = Nidyx::Pointer.new("#/path/to")
    assert_equal("", ptr.source)
    assert_equal(["path", "to"], ptr.path)

    ptr = Nidyx::Pointer.new("#path/to")
    assert_equal("", ptr.source)
    assert_equal(["path", "to"], ptr.path)
  end

  def test_empty_pointer
    ptr = Nidyx::Pointer.new("#/")
    assert_equal("", ptr.source)
    assert_equal([], ptr.path)

    ptr = Nidyx::Pointer.new("#")
    assert_equal("", ptr.source)
    assert_equal([], ptr.path)
  end
end
