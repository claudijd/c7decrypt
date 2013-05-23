begin
  require 'simplecov'
  SimpleCov.start
rescue LoadError
  warn "Couldn't load simplecov, so coverage reports will be generated"
  warn "Run 'gem install simplecov' to get coverage reports"
end
