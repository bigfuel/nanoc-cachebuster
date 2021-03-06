$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'nanoc3/cachebuster/version'

task :build do
  sh 'gem build nanoc-cachebuster.gemspec'
end

desc 'Install the gem locally'
task :install => :build do
  sh "gem install nanoc-cachebuster-#{Nanoc3::Cachebuster::VERSION}.gem"
end

task :push do
  sh 'git push origin master'
  sh 'git push --tags'
end

task :log do
  changes = `git log --oneline $(git describe --abbrev=0 2>/dev/null)..HEAD`
  abort 'Nothing to do' if changes.empty?

  changes.gsub!(/^\w+/, '*')
  path = File.expand_path('../HISTORY.md', __FILE__)

  original_content = File.read(path)
  addition = "# #{Nanoc3::Cachebuster::VERSION}\n\n#{changes}"
  puts addition

  File.open(path, 'w') do |f|
    f.write "#{addition}\n#{original_content}"
  end
end

desc 'Tag the code, push upstream, build and push the gem'
task :release => [:install, :push] do
  sh "gem push nanoc-cachebuster-#{Nanoc3::Cachebuster::VERSION}.gem"
end

desc 'Print current version number'
task :version do
  puts Nanoc3::Cachebuster::VERSION
end

class Version
  def initialize(version_string)
    @major, @minor, @patch = version_string.split('.').map { |s| s.to_i }
  end

  def bump(part)
    case part
    when :major then @major, @minor, @patch = @major + 1, 0, 0
    when :minor then @minor, @patch = @minor + 1, 0
    when :patch then @patch += 1
    end
    self
  end

  def to_s
    [@major, @minor, @patch].join('.')
  end

  def write
    file = File.expand_path('../lib/nanoc3/cachebuster/version.rb', __FILE__)
    original_contents = File.read(file)
    File.open(file, 'w') do |f|
      f.write original_contents.gsub(/VERSION = ('|")\d+\.\d+\.\d+\1/, "VERSION = '#{to_s}'")
    end
    puts to_s
    to_s
  end
end

namespace :version do
  namespace :bump do
    desc 'Bump a major version'
    task :major do
      Version.new(Nanoc3::Cachebuster::VERSION).bump(:major).write
    end

    desc 'Bump a minor version'
    task :minor do
      Version.new(Nanoc3::Cachebuster::VERSION).bump(:minor).write
    end

    desc 'Bump a patch version'
    task :patch do
      Version.new(Nanoc3::Cachebuster::VERSION).bump(:patch).write
    end
  end
end
