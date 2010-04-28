module JavascriptFeatures
  module Compiler
    def self.compile
      lib_files = Dir.glob(Rails.root + '/public/javascripts/lib/**/*.js')
      init_files = [File.join(File.dirname(__FILE__), *%w[ .. .. assets init.js ])]
      feature_files = Dir.glob(Rails.root + '/public/javascripts/main/**/*.js')

      (lib_files + init_files + feature_files).map{|file| File.read(file) }.join("\n")
    end
  end
end
