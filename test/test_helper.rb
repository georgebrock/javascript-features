require 'shoulda'
require 'redgreen' unless ENV["TM_PID"]
require 'webrick'

require 'javascript_features'

class Test::Unit::TestCase
  attr_accessor :request, :response
end

module Rails
  def self.root
    File.join(File.dirname(__FILE__), 'fixtures')
  end
end

class TestServlet < ::WEBrick::HTTPServlet::AbstractServlet
  def initialize(server, pages)
    super server
    @pages = pages
  end

  def service(req, res)
    page = @pages[req.path]
    if page
      res.status = 200
      res['Content-Type'] = 'text/html'
      if page.is_a?(Hash)
        page[:headers].each{ |k,v| res[k] = v }
        res.body = page[:body]
      else
        res.body = page
      end
    elsif req.path =~ %r[^/javascripts/packaged/([^/]+).js$]
      res.status = 200
      res['Content-Type'] = 'text/javascript'
      res.body = JavascriptFeatures::Compiler.compile(:package => $1)
    else
      res.status = 404
      res['Content-Type'] = 'text/plain'
      res.body = 'Not found'
    end
  end
end
