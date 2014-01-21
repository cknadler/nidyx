require "minitest/autorun"
require "fileutils"

class TestComparison < Minitest::Test
  def setup
    FileUtils.mkdir_p(TMP_PATH)
  end

  def teardown
    FileUtils.rm_rf(TMP_PATH)
  end

  def test_simple_properties
    validate_files("simple_properties", :json_model)
  end

  def test_complex_properties
    validate_files("complex_properties", :json_model)
  end

  def test_defs_and_refs
    validate_files("defs_and_refs", :json_model)
  end

  def test_mantle
    validate_files("mantle", :mantle)
  end

  private

  ROOT = File.absolute_path(File.join(File.dirname(__FILE__), "../.."))
  TMP_PATH = File.join(ROOT, "tmp")
  EXAMPLES_PATH = File.join(ROOT, "examples")
  PREFIX = "Example"

  def validate_files(example_name, type)
    run_generate(example_name, type)

    Dir.foreach(TMP_PATH) do |f|
      validate_file(example_name, f) unless [".", ".."].include?(f)
    end
  end

  def run_generate(example_name, type)
    cmd = "bundle exec nidyx " <<
          example_schema_path(example_name) <<
          " #{PREFIX} #{TMP_PATH} -n "

    case type
    when :json_model
      cmd << "--json-model"
    when :mantle
      cmd << "--mantle"
    end

    assert(false) unless system(cmd)
  end

  def validate_file(ename, fname)
      assert_equal(IO.read(example_file_path(ename, fname)),
                   IO.read(tmp_file_path(fname)))
  end

  def tmp_file_path(file_name)
    File.join(TMP_PATH, file_name)
  end

  def example_file_path(example_name, file_name)
    File.join(EXAMPLES_PATH, example_name, file_name)
  end

  def example_schema_path(example_name)
    File.join(EXAMPLES_PATH, example_name, "#{example_name}.json.schema")
  end
end
