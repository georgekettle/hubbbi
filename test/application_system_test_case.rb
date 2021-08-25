require "test_helper"

Webdrivers::Chromedriver.update

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by ENV['MAGIC_TEST'] == '1' ? :chrome : :headless_chrome
end
