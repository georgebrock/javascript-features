require 'jsmin'

module JavascriptFeatures
  module Compiler
    def self.compile(options = {})
      defaults = {:minify => true, :package => 'main'}
      options = defaults.merge(options)

      files = files_for_package(options[:package])
      compiled = files.map{|file| File.read(file) }.join("\n")
      minified = JSMin.minify(compiled) if options[:minify]

      minified || compiled
    end

    def self.package_modified_time(package = 'main', options = {})
      files_for_package(package, options).map{|f| File.new(f).mtime }.max
    end

  private
    def self.files_for_package(package, options = {})
      lib_files = Dir.glob(Rails.root + '/public/javascripts/lib/**/*.js')
      lib_files += [File.join(File.dirname(__FILE__), *%w[ .. .. assets jquery.js ])] if options[:jquery]
      init_files = [File.join(File.dirname(__FILE__), *%w[ .. .. assets init.js ])]
      feature_files = Dir.glob(Rails.root + "public/javascripts/#{package}/**/*.js")
      lib_files + init_files + feature_files
    end
  end
end
