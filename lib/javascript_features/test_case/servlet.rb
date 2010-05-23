module JavascriptFeatures
  class TestCase
    class Servlet < ::WEBrick::HTTPServlet::AbstractServlet
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
  end
end
