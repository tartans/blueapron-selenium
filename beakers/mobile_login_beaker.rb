# Encoding: utf-8

describe "Mobile Login - Corporate Manager", :depth => 'shallow' do
	let(:mobile) { @formula_lab.mix('mobile') } 

	it 'try to mobile login and verify keypad' do
        mobile.login
        mobile.keypad_present.should be_true
        mobile.click_keypad_keys '0000'
        
    	mobile.nav_title_text.should eq 'Facilities'
    	mobile.select_facility 'RM'
    	mobile.nav_title_text.should eq 'Richmond1'
    	mobile.facility_actionable_tasks1
  	end
end
