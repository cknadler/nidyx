desc "run all tests"
task :test do
  $LOAD_PATH.unshift('lib', 'test')
  Dir.glob('./test/**/test_*.rb') { |f| require f }
end

desc "generates examples"
task :examples do
  dirs = Dir.entries("examples").reject { |f| !File.directory?("examples/#{f}") }
  dirs.each do |example_dir|
    next if [".", ".."].include?(example_dir)
    Dir.chdir("examples/#{example_dir}") do
      system("./generate.sh")
    end
  end
end

task :default => :test
