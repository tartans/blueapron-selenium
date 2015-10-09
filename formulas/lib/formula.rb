# Encoding: utf-8

# This is where you can define generic helper functions
# that are inhereted by your formulas.
# The ones below are borrowed from:
# http://elemental-selenium.com/tips/9-use-a-base-page-object

class Formula < ChemistryKit::Formula::Base

  attr_reader :driver

  def initialize(driver)
    @driver = driver
  end

  def visit(url='/')
    driver.get(ENV['BASE_URL'] + url)
  end

  def find(locator)
    driver.find_element locator
  end

  def find_all(locator)
    driver.find_elements locator
  end

  def clear(locator)
    find(locator).clear
  end

  def type(locator, input)
    find(locator).send_keys input
  end

  def click_on(locator)
    find(locator).click
  end

  def displayed?(locator)
    driver.find_element(locator).displayed?
    true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      false
  end

  def text_of(locator)
    find(locator).text
  end

  def title
    driver.title
  end

  def wait_for(seconds=5)
    Selenium::WebDriver::Wait.new(:timeout => seconds).until { yield }
  end

  def wait(seconds=5)
    Selenium::WebDriver::Wait.new(:timeout => seconds)
  end
end
