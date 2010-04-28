Gem::Specification.new do |s|
  s.name = 'javascript_features'
  s.version = '0.0.1'
  s.date = '2010-04-28'

  s.authors = ['George Brocklehurst']
  s.email = 'george.brocklehurst@gmail.com'
  s.homepage = 'http://georgebrock.com'

  s.files = ['test', 'lib/javascript_features']
  s.require_paths = ['lib']
  s.rubygems_version = '1.3.6'
  s.summary = 'Structured, unobtrusive JavaScript for Rails applications'

  s.add_development_dependency('shoulda')
  s.add_development_dependency('redgreen')
end
