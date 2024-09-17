require 'spec_helper.rb'

RSpec.describe GameFactory do
  before(:each) do
    @factory1 = GameFactory.new 
    @factory2 = GameFactory.new 
  end
  describe "#initialize" do
    it "exists" do
      expect(@factory1).to be_an_instance_of(GameFactory)
      expect(@factory2).to be_an_instance_of(GameFactory)
    end

    it 'has an empty array for games' do
      expect(@factory1.games).to eq([])
      expect(@factory2.games).to eq([])
    end
  end

  describe '#create_games' do
    it 'can create teams' do
      @factory1.create_games('./data/games_test.csv')

      expect(@factory1.games.count).to eq(32)

      expect(@factory1.games[0].game_id).to eq('2012030221')
      expect(@factory1.games[0].season).to eq('20122013')
      expect(@factory1.games[0].type).to eq('Postseason')
      expect(@factory1.games[0].date_time).to eq('5/16/13')
      expect(@factory1.games[0].away_team_id).to eq('3')
      expect(@factory1.games[0].home_team_id).to eq('6')
      expect(@factory1.games[0].away_goals).to eq('2')
      expect(@factory1.games[0].home_goals).to eq('3')
      expect(@factory1.games[0].venue).to eq('Toyota Stadium')
      expect(@factory1.games[0].venue_link).to eq('/api/v1/venues/null')

      expect(@factory2.games).to eq([])
    end
  end
end
