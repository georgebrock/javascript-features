Gem::Specification.new do |s|
  s.name = 'javascript_features'
  s.version = '0.1.0'
  s.date = '2011-03-09'

  s.authors = ['George Brocklehurst', 'Elliot Crosby-McCullough']
  s.email = 'george.brocklehurst@gmail.com'
  s.homepage = 'http://georgebrock.com'

  s.files = Dir['{test,lib,rails}/**/*']
  s.require_paths = ['lib']
  s.rubygems_version = '1.3.6'
  s.summary = 'Structured, unobtrusive JavaScript for Rails applications'

  s.add_dependency('jsmin')
  s.add_dependency('harmony')

  s.add_development_dependency('shoulda')
  s.add_development_dependency('redgreen')
  s.add_development_dependency('rack-test')
  s.add_development_dependency('jslint_on_rails')
  s.add_development_dependency('activesupport')
  s.add_development_dependency('json')
end
