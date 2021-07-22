Rack::Multipart::Parser.send(:remove_const, 'BUFSIZE') if Rack::Multipart::Parser.const_defined?('BUFSIZE')
Rack::Multipart::Parser.const_set('BUFSIZE', 10_000_000)
