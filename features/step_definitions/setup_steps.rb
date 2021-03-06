Given /^a rack (with|without) the session middleware$/ do |prep|
  @rack_builder = Rack::Builder.new
  @rack_builder.use Rack::Lint
  @rack_builder.use FakeSession if prep == 'with'
end

# Yes, they're not as DRY as possible, but I think they're more readable than
# a single step definition with a few captures and more complex checkings.

Given /^a rack with the anti\-CSRF middleware$/ do
  Given 'a rack with the session middleware'
  When 'I insert the anti-CSRF middleware'
end

Given /^a rack with the anti\-CSRF middleware and the :raise option$/ do
  Given 'a rack with the session middleware'
  When 'I insert the anti-CSRF middleware with the :raise option'
end

Given /^a rack with the anti\-CSRF middleware and the :skip option$/ do |table|
  Given 'a rack with the session middleware'
  When 'I insert the anti-CSRF middleware with the :skip option', table
end

Given /^a rack with the anti\-CSRF middleware and the :field option$/ do
  Given 'a rack with the session middleware'
  When 'I insert the anti-CSRF middleware with the :field option'
end

Given /^a rack with the anti\-CSRF middleware and the :key option$/ do
  Given 'a rack with the session middleware'
  When 'I insert the anti-CSRF middleware with the :key option'
end

# Yes, they're not as DRY as possible, but I think they're more readable than
# a single step definition with a few captures and more complex checkings.

When /^I insert the anti\-CSRF middleware$/ do
  @rack_builder.use Rack::Csrf
  toy_app
  @browser = Rack::Test::Session.new(Rack::MockSession.new(@app))
end

When /^I insert the anti\-CSRF middleware with the :raise option$/ do
  @rack_builder.use Rack::Csrf, :raise => true
  toy_app
  @browser = Rack::Test::Session.new(Rack::MockSession.new(@app))
end

When /^I insert the anti\-CSRF middleware with the :skip option$/ do |table|
  skippable = table.hashes.collect {|t| t.values}.flatten
  @rack_builder.use Rack::Csrf, :skip => skippable
  toy_app
  @browser = Rack::Test::Session.new(Rack::MockSession.new(@app))
end

When /^I insert the anti\-CSRF middleware with the :field option$/ do
  @rack_builder.use Rack::Csrf, :field => 'fantasy_name'
  toy_app
  @browser = Rack::Test::Session.new(Rack::MockSession.new(@app))
end

When /^I insert the anti\-CSRF middleware with the :key option$/ do
  @rack_builder.use Rack::Csrf, :key => 'fantasy_name'
  toy_app
  @browser = Rack::Test::Session.new(Rack::MockSession.new(@app))
end

Then /^I get a fully functional rack$/ do
  expect {Rack::MockRequest.new(@app).get('/')}.to_not raise_exception
end

Then /^I get an error message$/ do
  expect {Rack::MockRequest.new(@app).get('/')}.to raise_exception(
    Rack::Csrf::SessionUnavailable,
    'Rack::Csrf depends on session middleware')
end

def toy_app
  @rack_builder.run(lambda {|env| Rack::Response.new('Hello world!').finish})
  @app = @rack_builder.to_app
end
