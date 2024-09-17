require './spec/spec_helper'

RSpec.describe Stattracker do
  before(:each) do
    game_path = './data/games_test.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_team_test.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    @stat_tracker = Stattracker.new
    @stat_tracker1 = Stattracker.from_csv(locations)
  end

  describe '#initialize' do
    it 'exists' do
      expect(@stat_tracker).to be_an_instance_of(Stattracker)
      expect(@stat_tracker.all_games).to eq([])
      expect(@stat_tracker.all_teams).to eq([])
      expect(@stat_tracker.all_game_teams).to eq([])
    end
  end
  describe '#from_csv' do
    it 'can create a new Stattracker instance' do
      expect(@stat_tracker1).to_not eq(@stat_tracker)
    end

    it 'has created lists of variables' do
      expect(@stat_tracker1.all_games.count).to eq(32)
      expect(@stat_tracker1.all_teams.count).to eq(32)
      expect(@stat_tracker1.all_game_teams.count).to eq(29)
    end
  end

  describe '#highest_total_score' do
    it 'can generate the highest total score of a game if there is only one' do
      expect(true).to eq(false)
    end
    it 'can generate the highest total score of a game if there is multiple games with the highest score' do
      expect(true).to eq(false)
    end
  end

  describe '#lowest_total_score' do
    it 'can generate the lowest total score of a game if there is only one' do
      expect(true).to eq(false)
    end
    it 'can generate the lowest total score of a game if there is multiple games with the highest score' do
      expect(true).to eq(false)
    end
  end
end