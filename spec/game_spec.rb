require 'spec_helper.rb'

RSpec.describe Game do
  before(:each) do
    @game1 = Game.new(2012030221, 20122013, 'Postseason', '5/16/13', 3, 6, 2, 3, 'Toyota Stadium', '/api/v1/venues/null')
    @game2 = Game.new(2012030222, 20122013, 'Postseason', '5/19/13', 3, 6, 2, 3, 'Toyota Stadium', '/api/v1/venues/null')
  end
  

  describe "#initialize" do
    it "can exist" do
      expect(@game1).to be_an_instance_of(Game)
      expect(@game2).to be_an_instance_of(Game)
    end

    it 'has game_id' do
      expect(@game1.game_id).to eq(2012030221)
      expect(@game2.game_id).to eq(2012030222)

    end

    it 'has season' do
      expect(@game1.season).to eq(20122013)
      expect(@game2.season).to eq(20122013)
    end

    it 'has type' do
      expect(@game1.type).to eq('Postseason')
      expect(@game2.type).to eq('Postseason')
    end

    it 'has date_time' do
      expect(@game1.date_time).to eq('5/16/13')
      expect(@game2.date_time).to eq('5/19/13')
    end

    it 'has away_team_id' do
      expect(@game1.away_team_id).to eq(3)
      expect(@game2.away_team_id).to eq(3)
    end

    it 'has home_team_id' do
      expect(@game1.home_team_id).to eq(6)
      expect(@game2.home_team_id).to eq(6)
    end

    it 'has away_goals' do
      expect(@game1.away_goals).to eq(2)
      expect(@game2.away_goals).to eq(2)
    end

    it 'has home_goals' do
      expect(@game1.home_goals).to eq(3)
      expect(@game2.home_goals).to eq(3)
    end

    it 'has a venue' do
      expect(@game1.venue).to eq('Toyota Stadium')
      expect(@game2.venue).to eq('Toyota Stadium')
    end

    it 'has venue_link' do
      expect(@game1.venue_link).to eq('/api/v1/venues/null')
      expect(@game2.venue_link).to eq('/api/v1/venues/null')
    end
  end
end
