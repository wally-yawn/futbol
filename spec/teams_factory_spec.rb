require 'spec_helper'

RSpec.describe 'teams_factory' do
  before(:each) do
    @team_factory1 = Teams_factory.new
  end

  describe '#initialize' do
    it 'exists' do
      expect(@team_factory1).to be_an_instance_of(Teams_factory)
      expect(@team_factory1.teams).to eq([])
    end
  end

  describe '#create_teams' do
    it 'can create an array of teams from a csv' do
      expect(@team_factory1.teams).to eq([])
      @team_factory1.create_teams('./data/teams_test_2.csv')
      expect(@team_factory1.teams.length).to eq(32)
      expect(@team_factory1.teams[0]).to be_an_instance_of(Team)
      expect(@team_factory1.teams[0].team_id).to eq('1')
      expect(@team_factory1.teams[0].franchise_id).to eq('23')
      expect(@team_factory1.teams[0].teamName).to eq('Atlanta United')
      expect(@team_factory1.teams[0].abbreviation).to eq("ATL")
      expect(@team_factory1.teams[0].link).to eq("/api/v1/teams/1")
    end
  end
end
