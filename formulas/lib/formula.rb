# Encoding: utf-8

# This is where you can define generic helper functions
# that are inhereted by your formulas.
# The definitions below are written on top of: http://elemental-selenium.com/tips/9-use-a-base-page-object

require 'logging'

class Formula < ChemistryKit::Formula::Base

  attr_reader :driver
  
  def initialize(driver)
    @driver = driver
    @logger = Logging.logger['test steps']
    yield self if block_given?
  end

  #def log(string)
  #  @logger.info(string)
  #end

  def title
    driver.title
  end

  def visit(destination_url)
    if destination_url.include? 'http'
      url = destination_url
    else
      url = ENV['BASE_URL'] + destination_url
    end
    driver.get url unless current_url == url
  end

  def find(locator)
    driver.find_element(locator)
  end

  def find_all_of(locator)
    driver.find_elements(locator)
  end

  def hover_over(locator)
    if locator.is_a? Hash
      element = find(locator)
    else
      element = locator
    end
    driver.mouse.move_to(element)
  end

  def scroll_element_into_view(locator, extra_y = nil)
    find(locator).location_once_scrolled_into_view
    # scroll a bit extra in y direction(+ve scrolls page up)
    unless extra_y.nil?
      execute_script("window.scrollBy(0,#{extra_y})")
    end
  end

  def click_on(locator, x_coord = nil, y_coord = nil)
    if locator.is_a? Hash
      element = find(locator)
    else
      element = locator
    end

    # elements can change if an item is interacted with.  As a workaround, hover over the item to trigger the change,
    # ensure that the element is displayed, and then perform the click.
    if x_coord.nil? && y_coord.nil?
      element.click
    else
      driver.action.move_to(element, x_coord, y_coord).click.perform
    end

    # The Chrome driver seems really fast and causes intermittent failures due to looking for next elements before they're
    # loaded.  This is a work around that should get tests working on Chrome
    # TODO: investigate a smarter way to do this.
    sleep 1 if !driver.class.name.include?('Element') && driver.capabilities[:browser_name] == 'chrome'
  end

  def click_and_drag_item(item, target_x, target_y, target_end_element)
    if item.is_a? Hash
      element = find(item)
    else
      element = item
    end

    if target_end_element.is_a? Hash
      element_end = find(target_end_element)
    else
      element_end = target_end_element
    end

    driver.action.click_and_hold(element).perform
    sleep 2
    driver.action.move_to(element_end, target_x, target_y).perform
    driver.action.move_to(element).release.perform
  end

  def rescue_exceptions
    yield
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    false
  rescue Selenium::WebDriver::Error::TimeOutError
    false
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  rescue Selenium::WebDriver::Error::UnknownError
    false
  end

  def displayed?(locator)
    rescue_exceptions { find(locator).displayed? }
  end

  def not_displayed?(locator)
    rescue_exceptions { find(locator).displayed? } == false
  end

  # Return whether an element is disabled (and therefore unclickable)
  def disabled?(locator)
    rescue_exceptions { find(locator).attribute('disabled') }
  end

  def enabled?(locator)
    rescue_exceptions { find(locator).enabled? }
  end

  def text_of(locator)
    if locator.is_a? Hash
      find(locator).text
    else
      locator.text
    end
  end

  def link_of(locator)
    find(locator).attribute('href')
  end

  def value_of(locator)
    attribute_of(locator, 'value')
  end

  def attribute_of(locator, attr)
    find(locator).attribute(attr)
  end

  def type(locator, text)
    find(locator).send_keys text
  end

  # PCI compliance each cc field is within a frame.  Need to enter the frame, find and type, exit the frame.
  # frame_id is the id and not the object.
  def find_frame_element_and_type(frame_id, locator, text)
    driver.switch_to.frame(frame_id)
    find(locator).send_keys text
    driver.switch_to.default_content()
  end

  def press(key)
    driver.action.send_keys(key).perform
  end

  def press_enter_on_element(locator)
    find(locator).send_keys :return
  end

  def double_click_on(locator)
    driver.action.double_click(locator).perform
  end

  def clear(locator)
    find(locator).clear
  end

  def submit(locator)
    find(locator).submit
  end

  def select(locator, selection)
    drop_down_list = find(locator)
    Selenium::WebDriver::Support::Select.new(drop_down_list).select_by(:text, selection)
  end

  def alert_displayed?
    begin
      driver.switch_to.alert
    rescue
      return false
    end
    true
  end

  def accept_alert
    alert = driver.switch_to.alert
    alert.accept
    true
  end

  def dismiss_alert
    alert = driver.switch_to.alert
    alert.dismiss
  end

  def get_window_handle
    driver.window_handle
  end

  alias_method :current_window, :get_window_handle

  def get_window_handles
    driver.window_handles
  end

  def number_of_windows
    get_window_handles.count
  end

  def wait_for_multiple_windows
    try(attempts: 5, sleep: 1) { number_of_windows > 1 }
  end

  def get_new_window_handle_from(main_window)
    all_windows = get_window_handles
    all_windows.each do |window|
      return window if main_window != window
    end
  end

  def switch_to_new_window_from(main_window)
    wait_for_multiple_windows
    all_windows = get_window_handles
    all_windows.each do |window|
      switch_to_window window if main_window != window
    end
  end

  def switch_to_window(window)
    driver.switch_to.window window
  end

  def current_url
    driver.current_url
  end

  def wait(seconds = 2)
    Selenium::WebDriver::Wait.new(timeout: seconds).until { yield }
  end

  alias_method :wait_for, :wait
  alias_method :wait_until, :wait

  def refresh
    driver.navigate.refresh
  end

  def execute_script(script)
    driver.execute_script script
  end

  def download_file_from_url(url)
    require 'rest-client'
    RestClient.get url
  end

  def raise_unknown_option_error(selection)
    raise ArgumentError, "Unknown option #{selection} provided!"
  end

  def try(args = {})
    count              = 0
    object_of_interest = false
    until object_of_interest || count == args[:attempts]
      object_of_interest = rescue_exceptions { yield }
      sleep args[:sleep]
      count += 1
    end
    object_of_interest
  end

  def is_chrome
    return false unless !driver.class.name.include?('Element') && driver.capabilities[:browser_name] == 'chrome'
    true
  end

  def retry_on_failure(retries = 3)
    yield
  rescue Selenium::WebDriver::Error::NoSuchElementError => e
    retry unless (retries -= 1).zero?
    raise e
  rescue Selenium::WebDriver::Error::TimeOutError => e
    retry unless (retries -= 1).zero?
    raise e
  rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
    retry unless (retries -= 1).zero?
    raise e
  rescue Selenium::WebDriver::Error::UnknownError => e
    retry unless (retries -= 1).zero?
    raise e
  end

  private

end # Formula
