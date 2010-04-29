Gem::Specification.new do |s|
  s.name = 'javascript_features'
  s.version = '0.0.1'
  s.date = '2010-04-28'

  s.authors = ['George Brocklehurst']
  s.email = 'george.brocklehurst@gmail.com'
  s.homepage = 'http://georgebrock.com'

  s.files = Dir['{test,lib,rails}/**/*']
  s.require_paths = ['lib']
  s.rubygems_version = '1.3.6'
  s.summary = 'Structured, unobtrusive JavaScript for Rails applications'

  s.add_dependency('jsmin')

  s.add_development_dependency('shoulda')
  s.add_development_dependency('redgreen')
  s.add_development_dependency('harmony')
end
