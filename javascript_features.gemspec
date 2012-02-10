Gem::Specification.new do |s|
  s.name = 'javascript_features'
  s.version = '1.0.3'
  s.date = '2011-05-24'

  s.authors = ['George Brocklehurst']
  s.email = 'george.brocklehurst@gmail.com'
  s.homepage = 'http://georgebrock.com'

  s.files = Dir['{test,lib,rails,assets}/**/*']
  s.require_paths = ['lib']
  s.rubygems_version = '1.3.6'
  s.summary = 'Structured, unobtrusive JavaScript for Rails applications'

  s.add_dependency('jsmin')

  s.add_development_dependency('harmony')
  s.add_development_dependency('shoulda')
  s.add_development_dependency('redgreen')
  s.add_development_dependency('rack-test')
  s.add_development_dependency('jslint_on_rails')
  s.add_development_dependency('activesupport')
  s.add_development_dependency('json')
end
