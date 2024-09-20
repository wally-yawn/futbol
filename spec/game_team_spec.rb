require './lib/game_team'

RSpec.describe 'GameTeam' do
  before(:each) do
    @row = { game_id: '2012030221',
             team_id: '3',
             hoa: 'away',
             result: 'LOSS',
             settled_in: 'OT',
             head_coach: 'John Tortorella',
             goals: '2',
             shots: '8',
             tackles: '44',
             pim: '8',
             powerPlayOpportunities: '3',
             powerPlayGoals: '0',
             faceOffWinPercentage: '44.8',
             giveaways: '17',
             takeaways: '7' }

    @game_team1 = GameTeam.new(@row)
  end

  describe '#initialize' do
    it 'exists' do
      expect(@game_team1).to be_an_instance_of(GameTeam)
    end
  end

  describe '#create_game_teams' do
    it 'has attributes' do
      expect(@game_team1.game_id).to eq('2012030221')
      expect(@game_team1.team_id).to eq('3')
      expect(@game_team1.hoa).to eq('away')
      expect(@game_team1.result).to eq('LOSS')
      expect(@game_team1.settled_in).to eq('OT')
      expect(@game_team1.head_coach).to eq('John Tortorella')
      expect(@game_team1.goals).to eq(2)
      expect(@game_team1.shots).to eq(8)
      expect(@game_team1.tackles).to eq(44)
      expect(@game_team1.powerPlayOpportunities).to eq(3)
      expect(@game_team1.powerPlayGoals).to eq(0)
      expect(@game_team1.faceOffWinPercentage).to eq(44.8)
      expect(@game_team1.takeaways).to eq(7)
    end
  end
end
