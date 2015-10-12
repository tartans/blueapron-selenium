# Encoding: utf-8

describe "Mobile Login - Inventory Control", :depth => 'shallow' do
    let(:mobile) { @formula_lab.mix('mobile') } 

    it 'Inventory Control - Move Pallet' do
        mobile.login
        mobile.keypad_present.should be_true
        mobile.click_keypad_keys '0000'
        
        mobile.nav_title_text.should eq 'Facilities'
        mobile.select_facility 'RM'
        mobile.nav_title_text.should eq 'Richmond'

        mobile.check_out_inventory
        mobile.
    end
end
