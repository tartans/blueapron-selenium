module Formulas
  class Desktop < Formula
    SIGN_IN_FORM            = { css: '.sign-in-form' }      
    LOGIN_TEXTBOX           = { css: '[type="text"]' }      
    PASSWORD_TEXTBOX        = { css: '[type*="password"]' }
    SUBMIT_BUTTON           = { css: '.btn.mr-10'     }
    USER_NAV_BAR            = { css: '.nav-dropdown__toggle'  }
    FORM_SEARCH_TEXTBOX     = { css: '.form-search' }

    def initialize(driver)
      super
      visit '/sessions/new'
      verify_page
    end

    def login()
      type LOGIN_TEXTBOX, 'leo.rogers@blueapron.com'
      type PASSWORD_TEXTBOX, 'larba334'
      click_on SUBMIT_BUTTON
    end

    def verify_login
      wait_for(5) {not displayed? (SIGN_IN_FORM)}
      displayed? (FORM_SEARCH_TEXTBOX)
    end

    private

      def verify_page
        displayed? SIGN_IN_FORM
      end

  end # Desktop
end # Formulas