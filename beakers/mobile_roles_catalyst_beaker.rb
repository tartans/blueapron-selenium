# Encoding: utf-8

require 'csv'

describe "mobile login", :depth => 'shallow' do
	csv_text = File.read(File.expand_path('../../catalyst/mobile_roles.csv', __FILE__))
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
        context '' do
            let(:mobile) { @formula_lab.mix('mobile') } 

            it "#{row['Key']} - #{row['Type']} - #{row['Enumber']}" do
                mobile.manager_login
                mobile.employee_login "#{row['Enumber']}"

                mobile.keypad_present.should be_true
                mobile.click_keypad_keys "#{row['Pin']}"

                mobile.url.should include("#{row['Url']}")
                mobile.nav_title_text.should eq "#{row['Title']}"

                mobile.user_settings
                #mobile.select_facility 'RM'
                #mobile.nav_title_text.should eq 'Richmond'
                #mobile.facility_actionable_tasks1
            end
      	end
    end
end
