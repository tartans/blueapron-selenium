describe "desktop login", :depth => 'deep' do
	let(:desktop) { @formula_lab.mix('desktop') } 

	it 'try to desktop login' do
		desktop.login
		desktop.verify_login.should be_true
  	end
end
