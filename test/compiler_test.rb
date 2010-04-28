require File.join(File.dirname(__FILE__), *%w[test_helper])

class CompilerTest < Test::Unit::TestCase

  context 'compiling the main JavaScript package' do
    setup do
      @compiled_script = JavascriptFeatures::Compiler.compile
    end

    should 'concatenate the relevant files in the correct order' do
      files = [
        File.join(Rails.root, *%w[ public javascripts lib jquery.js ]),
        File.join(File.dirname(__FILE__), *%w[ .. assets init.js ]),
        File.join(Rails.root, *%w[ public javascripts main my_feature.js ])
      ]

      assert_equal files.map{|f| File.read(f) }.join("\n"), @compiled_script
    end
  end

end
