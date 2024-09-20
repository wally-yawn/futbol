require 'spec_helper'

RSpec.describe 'team' do
  before(:each) do
    row = {team_id: '1',franchiseId:'2',teamName: 'The Capybaras',abbreviation: 'CAP',Stadium: "Wally\'s World" ,link: 'http:\\google.com'}
    @team1 = Team.new(row)
  end

  describe '#initialize' do
    it 'exists' do
      expect(@team1).to be_an_instance_of(Team)
      expect(@team1.team_id).to eq('1')
      expect(@team1.franchise_id).to eq('2')
      expect(@team1.teamName).to eq('The Capybaras')
      expect(@team1.abbreviation).to eq("CAP")
      expect(@team1.link).to eq("http:\\google.com")
    end
  end
end
