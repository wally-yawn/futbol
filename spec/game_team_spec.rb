require './lib/game_team'

RSpec.describe 'game_team' do
  before(:each) do
    @game_team = Gameteam.new(2012030221, 3, "away", "LOSS", "OT", "John Tortorella", 2, 8, 44, 8, 3, 0, 44.8, 17, 7)
  end

  it 'exists and has attributes' do
    expect(@game_team).to be_an_instance_of(Gameteam)
    expect(@game_team.game_id).to eq(2012030221)
    expect(@game_team.team_id).to eq(3)
    expect(@game_team.hoa).to eq("away")
    expect(@game_team.result).to eq("LOSS")
    expect(@game_team.settled_in).to eq("OT")
    expect(@game_team.head_coach).to eq("John Tortorella")
    expect(@game_team.goals).to eq(2)
    expect(@game_team.shots).to eq(8)
    expect(@game_team.tackles).to eq(44)
    expect(@game_team.pim).to eq(8)
    expect(@game_team.powerPlayOpportunities).to eq(3)
    expect(@game_team.powerPlayGoals).to eq(0)
    expect(@game_team.faceOffWinPercentage).to eq(44.8)
    expect(@game_team.giveaways).to eq(17)
    expect(@game_team.takeaways).to eq(7)
  end
end