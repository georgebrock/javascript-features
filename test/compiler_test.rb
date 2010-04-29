require 'jsmin'
require File.join(File.dirname(__FILE__), *%w[test_helper])

class CompilerTest < Test::Unit::TestCase

  def setup
    common_files = [
      File.join(Rails.root, *%w[ public javascripts lib jquery.js ]),
      File.join(File.dirname(__FILE__), *%w[ .. assets init.js ])
    ]

    @main_files = common_files + [ File.join(Rails.root, *%w[ public javascripts main my_feature.js ]) ]
    @alternative_files = common_files + [ File.join(Rails.root, *%w[ public javascripts alternative alternative.js ]) ]
  end

  context 'compiling the main JavaScript package' do
    should 'concatenate the relevant files in the correct order and minify the result' do
      assert_equal JSMin.minify(@main_files.map{|f| File.read(f) }.join("\n")), JavascriptFeatures::Compiler.compile
    end

    should 'optionally disable minification' do
      assert_equal @main_files.map{|f| File.read(f) }.join("\n"), JavascriptFeatures::Compiler.compile(:minify => false)
    end
  end

  context 'compiling the alternative JavaScript package' do
    should 'take feature files from the /alternative directory instead of /main' do
      assert_equal JSMin.minify(@alternative_files.map{|f| File.read(f) }.join("\n")), JavascriptFeatures::Compiler.compile(:package => 'alternative')
    end
  end

end
