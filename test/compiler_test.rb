require 'jsmin'
require File.join(File.dirname(__FILE__), *%w[test_helper])

class CompilerTest < Test::Unit::TestCase

  def setup
    @files = [
      File.join(Rails.root, *%w[ public javascripts lib jquery.js ]),
      File.join(File.dirname(__FILE__), *%w[ .. assets init.js ]),
      File.join(Rails.root, *%w[ public javascripts main my_feature.js ])
    ]
  end

  context 'compiling the main JavaScript package' do
    should 'concatenate the relevant files in the correct order and minify the result' do
      assert_equal JSMin.minify(@files.map{|f| File.read(f) }.join("\n")), JavascriptFeatures::Compiler.compile
    end

    should 'optionally disable minification' do
      assert_equal @files.map{|f| File.read(f) }.join("\n"), JavascriptFeatures::Compiler.compile(:minify => false)
    end
  end

end
