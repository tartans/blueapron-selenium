describe "desktop login", :depth => 'shallow' do
	let(:mobile) { @formula_lab.mix('mobile') } 

	it 'try to mobile login and verify keypad' do
        mobile.login
    	mobile.keypad_present.should be_true
    	#mobile.click_keypad_key
        mobile.click_key(0)
        mobile.click_key(0)
        mobile.click_key(0)
        mobile.click_key(0)
        
    	mobile.nav_title_text.should eq 'Facilities'

    	mobile.select_facility 'RM'
    	mobile.nav_title_text.should eq 'Richmond'
    	mobile.facility_actionable_tasks1
  	end
end
