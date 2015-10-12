module Formulas
  class Mobile < Formula

    # Generic / Header / Multi-purchase Controls
    NAV_TITLE               = { css: '.nav__title'}
    HEADER_EMPLOYEE_INFO    = { css: '.header__right'}
    MANAGER_LOGIN_TEXTBOX   = { css: '[name="manager-scan"]' }
    EMPLOYEE_LOGIN_TEXTBOX  = { css: '[name="employee-scan"]' }
    ICON_SCAN_INDICATOR     = { css: '.scan-indicator' }
    TEXTBOX_QR_CODE         = { css: '.ember-text-field' }

    # EMPLOYEES CONTROLS
    EMPLOYEE_USER           = { css: '[data-employee="user"]' }
    EMPLOYEE_BRANCH         = { css: '[data-employee="branch"]' }
    EMPLOYEE_ROLE           = { css: '[data-employee="role"]' }

    # Login Controls
    SUBMIT_BUTTON           = { css: '.btn' }
    KEYPAD                  = { css: '.keypad' }
    KEYPAD_KEY              = { css: '.keypad-key' }
    KEYPAY_KEY_1            = { css: '[data-keypad-key="1"]' }
    KEYPAY_KEY_2            = { css: '[data-keypad-key="2"]' }
    KEYPAY_KEY_3            = { css: '[data-keypad-key="3"]' }
    KEYPAY_KEY_4            = { css: '[data-keypad-key="4"]' }
    KEYPAY_KEY_5            = { css: '[data-keypad-key="5"]' }
    KEYPAY_KEY_6            = { css: '[data-keypad-key="6"]' }
    KEYPAY_KEY_7            = { css: '[data-keypad-key="7"]' }
    KEYPAY_KEY_8            = { css: '[data-keypad-key="8"]' }
    KEYPAY_KEY_9            = { css: '[data-keypad-key="9"]' }
    KEYPAY_KEY_0            = { css: '[data-keypad-key="0"]' }

    # GM - Main Menu Tasks
    TASK_INVENTORY_CONTROL      = { css: '[data-role="inventory-control"]' }
    TASK_PACK_LINE              = { css: '[data-role="pack-line"]' }
    TASK_CHECKOUT_INVENTORY     = { css: '[data-role="checkout-inventory"]' }
    TASK_QUALITY_CONTROL        = { css: '[data-role="quality-control"]' }

    # Container Controls
    CONTAINER_INFO_ITEM_CONTENT = { css: '.item-content__left' }
    CONTAINER_INFO_ITEM_COUNT   = { css: '.item-content__right' }
    CONTAINER_INFO_LOCATION     = { css: '.need_id1' }  # need id
    CONTAINER_INFO_AMT_CASE     = { css: '.need_id1' }  # need id
    CONTAINER_INFO_PALLET_ID    = { css: '.need_id1' }  # need id




    def initialize (driver)
      super
      visit '/mobile'
      verify_page
    end

    def login
      wait_for { displayed? (MANAGER_LOGIN_TEXTBOX) }
      type MANAGER_LOGIN_TEXTBOX, '3635'
      click_on SUBMIT_BUTTON

      wait_for { displayed? (EMPLOYEE_LOGIN_TEXTBOX) }
      type EMPLOYEE_LOGIN_TEXTBOX, '3635'
      wait_for (5) { displayed? (SUBMIT_BUTTON) }
      click_on SUBMIT_BUTTON
    end

    def manager_login
      wait_for { displayed? (MANAGER_LOGIN_TEXTBOX) }
      type MANAGER_LOGIN_TEXTBOX, '3635'
      wait_for (5) { displayed? (SUBMIT_BUTTON) }
      click_on SUBMIT_BUTTON
    end

    def employee_login (employee_number)
      wait_for { displayed? (EMPLOYEE_LOGIN_TEXTBOX) }
      type EMPLOYEE_LOGIN_TEXTBOX, employee_number
      wait_for (5) { displayed? (SUBMIT_BUTTON) }
      click_on SUBMIT_BUTTON
    end

    def user_settings
      click_on HEADER_EMPLOYEE_INFO
      puts text_of(EMPLOYEE_USER)
      puts text_of(EMPLOYEE_BRANCH)
      puts text_of(EMPLOYEE_ROLE)
    end

    def keypad_present
      wait_for (5) { displayed? (KEYPAD) }
    end

    def click_keypad_keys (pin)
      click_key pin[0].to_i
      click_key pin[1].to_i
      click_key pin[2].to_i
      click_key pin[3].to_i
    end

    def url
      current_url
    end

    def click_key (key)
      case key
        when 1
          click_on KEYPAY_KEY_1
        when 2
          click_on KEYPAY_KEY_2
        when 3
          click_on KEYPAY_KEY_3
        when 4
          click_on KEYPAY_KEY_4
        when 5
          click_on KEYPAY_KEY_5
        when 6
          click_on KEYPAY_KEY_6
        when 7
          click_on KEYPAY_KEY_7
        when 8
          click_on KEYPAY_KEY_8
        when 9
          click_on KEYPAY_KEY_9
        when 0
          click_on KEYPAY_KEY_0
      end
    end

    def nav_title_text
      wait_for { displayed? (NAV_TITLE) }
      text_of(NAV_TITLE)
    end

    def select_facility(warehouse_code)
      #puts displayed? RICHMOND_SPAN
      case warehouse_code  # was case obj.class
        when 'RM'
          visit '/mobile/facilities/2'
        when 'JC'
          visit '/mobile/facilities/3'
        when 'AR'
          visit '/mobile/facilities/4'
      end
    end

    def facility_actionable_tasks1
      puts displayed? (TASK_INVENTORY_CONTROL)
      puts displayed? (TASK_PACK_LINE)
      puts displayed? (TASK_CHECKOUT_INVENTORY)
      puts displayed? (TASK_QUALITY_CONTROL)
    end

    def inventory_control
      click_on TASK_INVENTORY_CONTROL
      wait_for { displayed? (ICON_QR_SCAN_INDICATOR) }
      type TEXTBOX_QR_CODE 'PAL-RM-FHH'
    end

    def check_out_inventory
      click_on TASK_CHECKOUT_INVENTORY
      wait_for { displayed? (ICON_QR_SCAN_INDICATOR) }
      type TEXTBOX_QR_CODE 'PAL-RM-FHH'

      wait_for { displayed? (CONTAINER_INFO_ITEM_CONTENT) }
      text_of CONTAINER_INFO_ITEM_CONTENT
      text_of CONTAINER_INFO_ITEM_COUNT
    end

    def item_content

    end

    def item_count
    
    end

    private

      def verify_page
        title.include?('Blueradish').should == true
      end

  end # Mobile
end # Formulas