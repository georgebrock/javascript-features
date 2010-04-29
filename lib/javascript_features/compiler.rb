require 'jsmin'

module JavascriptFeatures
  module Compiler
    def self.compile(options = {})
      defaults = {:minify => true, :package => 'main'}
      options = defaults.merge(options)

      lib_files = [File.join(File.dirname(__FILE__), *%w[ .. .. assets jquery.js ])] + Dir.glob(Rails.root + '/public/javascripts/lib/**/*.js')
      init_files = [File.join(File.dirname(__FILE__), *%w[ .. .. assets init.js ])]
      feature_files = Dir.glob(Rails.root + "/public/javascripts/#{options[:package]}/**/*.js")

      compiled = (lib_files + init_files + feature_files).map{|file| File.read(file) }.join("\n")
      minified = JSMin.minify(compiled) if options[:minify]

      minified || compiled
    end
  end
end
