require './spec/spec_helper'

RSpec.describe StatTracker do
  before(:each) do
    game_path = './data/games_test.csv'
    team_path = './data/teams_test_2.csv'
    team_path_2 = './data/teams_test.csv'
    game_teams_path = './data/game_team_test.csv'
    game_path_2 = './data/games_test_2.csv'
    game_path_3 = './data/games_test_3.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    locations2 = {
      games: game_path_2,
      teams: team_path_2,
      game_teams: game_teams_path
    }

    locations3 = {
      games: game_path_3,
      teams: team_path_2,
      game_teams: game_teams_path
    }
    @stat_tracker = StatTracker.new
    @stat_tracker1 = StatTracker.from_csv(locations)
    @stat_tracker2 = StatTracker.from_csv(locations2)
    @stat_tracker3 = StatTracker.from_csv(locations3)
  end

  describe '#initialize' do
    it 'exists' do
      expect(@stat_tracker).to be_an_instance_of(StatTracker)
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
  describe '#calculate percentages' do
    it 'can calculate home wins' do
      expect(@stat_tracker1.percentage_home_wins).to eq(0.69)
    end

    it 'can calculate visitor wins' do
      expect(@stat_tracker1.percentage_visitor_wins).to eq(0.28)
    end

    it 'can calculate ties' do
      expect(@stat_tracker1.percentage_ties).to eq(0.03)
    end

    it 'can calculate accurately' do
      total = (@stat_tracker1.percentage_ties) + (@stat_tracker1.percentage_visitor_wins) + (@stat_tracker1.percentage_home_wins)
      expect(total).to be_within(0.003).of(1.0000)
    end
  end

  describe '#highest_total_score' do
    it 'returns the highest sum of the winning and losing teams’ scores' do
      expect(@stat_tracker1.highest_total_score).to eq(5)
    end
  end

  describe '#lowest_total_score' do
    it 'returns the lowest sum of the winning and losing teams’ scores' do
      expect(@stat_tracker1.lowest_total_score).to eq(1)
    end
  end

  describe '#get_scores' do
    it 'returns an array of all scores for a team_id' do
      expect(@stat_tracker1.get_scores(6)).to eq([3, 3, 3, 2, 1, 2, 3, 3, 4])
      expect(@stat_tracker1.get_scores('6')).to eq([3, 3, 3, 2, 1, 2, 3, 3, 4])
      expect(@stat_tracker1.get_scores('1')).to eq([0])

      expect(@stat_tracker1.get_scores(6, :home)).to eq([3, 3, 3, 2, 1])
      expect(@stat_tracker1.get_scores(6, :away)).to eq([2, 3, 3, 4])
      expect(@stat_tracker1.get_scores(6, :total)).to eq([3, 3, 3, 2, 1, 2, 3, 3, 4])
      expect(@stat_tracker1.get_scores(6, :blahblah)).to eq([3, 3, 3, 2, 1, 2, 3, 3, 4])
    end
  end
 
  describe '#highest_scoring_home_team' do
    it 'can find the highest scoring home team' do
      expect(@stat_tracker2.highest_scoring_home_team).to eq('New York City FC')
    end
  end

  describe '#highest_scoring_visitor' do
    it 'can find the highest scoring visiting team' do
      expect(@stat_tracker2.highest_scoring_visitor).to eq('FC Dallas')
    end
  end

  describe '#lowest_scoring_home_team' do
    it 'can find the lowest scoring home team' do
      expect(@stat_tracker2.lowest_scoring_home_team).to eq('Sporting Kansas City')
    end
  end

  describe '#lowest_scoring_visitor' do
    it 'can find the lowest scoring visiting team' do
      expect(@stat_tracker2.lowest_scoring_visitor).to eq('LA Galaxy')
    end
  end
  
  describe '#coach_win_percentages' do
    it 'calculates winning percentages of coaches' do
      expected = {
        "Claude Julien"=>100, 
        "Dan Bylsma"=>0, 
        "Joel Quenneville"=>33, 
        "John Tortorella"=>0, 
        "Mike Babcock"=>60
      }
      expect(@stat_tracker1.send(:coach_win_percentages,nil)).to eq(expected)
    end
  end

  describe '#winningest_coach' do
    it 'returns highest winning percentage coach' do
      expect(@stat_tracker1.winningest_coach(20122013)).to eq("Claude Julien")
      expect(@stat_tracker1.winningest_coach(20122013)).not_to eq("John Tortorella")
    end
  end

  describe '#worst_coach' do
    it 'returns lowest percentage coach' do
      expect(@stat_tracker1.worst_coach(20122013)).to eq("John Tortorella")
      expect(@stat_tracker1.worst_coach(20122013)).not_to eq("Claude Julien")
    end
  end

  describe '#average_goals_per_game' do
    it 'calculates the correct average' do
      expect(@stat_tracker1.average_goals_per_game).to eq(3.75)
      expect(@stat_tracker1.average_goals_per_game).to_not eq(4)
    end
  end

  describe '#average_goals_by_season' do
    it 'calculates average goals by season' do
      avg = @stat_tracker1.average_goals_by_season
      expect(avg['20122013']).to eq(3.75)
    end
  end

  describe '#games_by_season' do
    it 'returns a hash of games by season' do
      expect(@stat_tracker1.count_of_games_by_season).to be_a(Hash)
      games = @stat_tracker1.count_of_games_by_season
      expect(games['20122013']).to eq 32
      expect(games['20112012']).to eq 0
    end
  end

  describe '#get_seasons' do
    it 'returns an array of seasons for al games' do
      expect(@stat_tracker1.get_seasons.first).to eq "20122013"
      expect(@stat_tracker1.get_seasons.last).to eq "20122013"
    end
  end

  describe '#total_games' do
    it 'returns total games count' do
      expect(@stat_tracker1.total_games).to eq 32
    end
  end

  describe '#get_games' do
    it 'returns an array of games for team_id' do
      games = @stat_tracker1.get_games(6, :away)
      expect(games.count).to eq 4
      games = @stat_tracker1.get_games(6, :home)
      expect(games.count).to eq 5

    end
  end

  describe '#count_of_all_goals' do
    it 'counts all goals' do
      expect(@stat_tracker1.count_of_all_goals).to eq(120)
      expect(@stat_tracker1.count_of_all_goals).to_not eq(0)
    end
  end

  describe '#offensive performance' do
    it 'can show the best offense overall' do
      expect(@stat_tracker1.best_offense).to eq("FC Dallas")
    end
    it 'can show the worst offense overall' do
      expect(@stat_tracker1.worst_offense).to eq("Sporting Kansas City")
    end 
  end

  describe '#count_of_games_by_season' do
    it 'can give a count of games by season' do
      expect(@stat_tracker2.count_of_games_by_season['20122013']).to eq(29)
      expect(@stat_tracker2.count_of_games_by_season['20142015']).to eq(0)
    end
  end

  describe '#team_shot_goal_ratio' do
    it 'calculates accuracy ratio of a team' do
      expect = {
        "Atlanta United"=>0,
        "Chicago Fire"=>0,
        "FC Cincinnati"=>0,
        "DC United"=>0,
         "FC Dallas"=>0.3157894736842105,
        "Houston Dynamo"=>0.21052631578947367,
         "Sporting Kansas City"=>0.0625,
      }
      expect(@stat_tracker1.team_shot_goal_ratios).to include(expect)
    end

    it 'calculates accuracy ratios for a specific season' do
      expect = {
        "Atlanta United"=>0,
        "Chicago Fire"=>0,
        "FC Cincinnati"=>0,
        "DC United"=>0,
        "FC Dallas"=>0.3157894736842105,
        "Houston Dynamo"=>0.21052631578947367,
      }
      expect(@stat_tracker1.team_shot_goal_ratios('20122013')).to include(expect)
    end
  end

  describe '#most_accurate_team' do
    it 'shows the team with the highest goal average' do
      expect(@stat_tracker1.most_accurate_team).to eq("FC Dallas")
    end

    it 'shows most accurate team in the season' do
      expect(@stat_tracker1.most_accurate_team('20122013')).to eq("FC Dallas")
      expect(@stat_tracker1.most_accurate_team('20142015')).to eq("Atlanta United")
    end
  end

  describe '#least_accurate_team' do
    it 'shows the team with the lowest goal average' do
      expect(@stat_tracker1.least_accurate_team).to eq("Sporting Kansas City")
    end
  end

  describe '#least_accurate_team by season' do
    it 'shows least accurate team in the season' do
      expect(@stat_tracker1.least_accurate_team('20122013')).to eq("Sporting Kansas City")
      expect(@stat_tracker2.least_accurate_team('20132014')).to eq("FC Dallas")
    end
  end

  describe '#team_tackle_total' do
    it 'makes a list of teams with tackle scores' do
      expect = {
        "Atlanta United"=>0,
        "Chicago Fire"=>0,
        "FC Cincinnati"=>0,
        "DC United"=>0,
        "FC Dallas"=>271,
        "Houston Dynamo"=>179
    }
      expect(@stat_tracker1.team_tackle_total).to include(expect)
    end

    it 'makes a list of team tackles by season' do
      expect = {
        "Atlanta United"=>0,
        "Chicago Fire"=>0,
        "FC Cincinnati"=>0,
        "DC United"=>0,
        "FC Dallas"=>271,
      }
      expect(@stat_tracker1.team_tackle_total('20122013')).to include(expect)
    end
  end

  describe '#most_tackles' do
    it 'shows the team with the most tackles' do
      expect(@stat_tracker1.most_tackles).to eq("FC Dallas")
    end

    it 'shows the team with the most tackles of the season' do
      expect(@stat_tracker1.most_tackles('20122013')).to eq("FC Dallas")
      expect(@stat_tracker1.most_tackles('20132014')).to eq("Atlanta United")
    end
  end

  describe '#fewest_tackles' do
    it 'shows the team with the fewest tackles' do
      expect(@stat_tracker1.fewest_tackles).to eq("New England Revolution")
    end

    it 'shows the team with the fewest tackles of the season' do
      expect(@stat_tracker1.fewest_tackles('20122013')).to eq("New England Revolution")
      expect(@stat_tracker2.fewest_tackles('20132014')).to eq("FC Dallas")
    end
  end

  describe '#count_teams' do 
    it 'shows the number of teams in the data' do 
      expect(@stat_tracker1.count_of_teams).to eq(32)
    end
  end

  describe '#team_info' do
    it 'can generate a hash of team info' do
      expected = {
        'team_id' => '9',
        'franchise_id' => '30',
        'team_name' => 'New York City FC',
        'abbreviation' => 'NYC',
        'link' => '/api/v1/teams/9'
      }
      expect(@stat_tracker1.team_info(9)).to eq(expected)
      expect(@stat_tracker1.team_info('9')).to eq(expected)
    end
  end

  describe '#average_win_percentage' do
    it 'can calculate the average win percentage for a team over all games' do
      expect(@stat_tracker1.average_win_percentage(19)).to eq(0.5)
      expect(@stat_tracker1.average_win_percentage('19')).to eq(0.5)
      expect(@stat_tracker1.average_win_percentage(9)).to eq(0.6) #has a tie 3wins 5 games
    end
  end

  describe '#fewest_goals_scored' do
    it 'can return the fewest amount of goals scored if there is only one' do
      expect(@stat_tracker1.fewest_goals_scored(16)).to eq(0)
      expect(@stat_tracker1.fewest_goals_scored('16')).to eq(0)
    end
    it 'can return the fewest amount of goals scored if there are multiple' do
      expect(@stat_tracker1.fewest_goals_scored(3)).to eq(1)
      expect(@stat_tracker1.fewest_goals_scored('3')).to eq(1)
    end
  end

  describe '#most_goals_scored' do
    it 'can return the most amount of goals scored if there is only one' do
      expect(@stat_tracker1.most_goals_scored(6)).to eq(4)
      expect(@stat_tracker1.most_goals_scored('6')).to eq(4)
    end
    it 'can return the most amount of goals scored if there are multiple' do
      expect(@stat_tracker1.most_goals_scored(3)).to eq(2)
      expect(@stat_tracker1.most_goals_scored('3')).to eq(2)
    end
  end

  describe '#worst loss do' do
    it 'records biggest losses' do
      expect(@stat_tracker1.worst_loss(3)).to eq(2)
      expect(@stat_tracker1.worst_loss(6)).to eq(0)
      expect(@stat_tracker1.worst_loss(6)).to_not eq(nil)
    end
  end

  describe '#best season' do 
    it 'can show the worst season for a team' do
      expect(@stat_tracker2.best_season(6)).to eq('20122013')
      expect(@stat_tracker2.best_season(6)).to be_a(String)
    end
  end

  describe '#worst season' do
    it 'can show the worst season' do
      expect(@stat_tracker2.worst_season(16)).to eq('20132014')
      expect(@stat_tracker2.worst_season(6)).to be_a(String)
    end
  end

  describe '#biggest_team_blowout' do
    it 'can find the biggest blowout' do
    expect(@stat_tracker1.biggest_team_blowout(6)).to eq 3
    expect(@stat_tracker1.biggest_team_blowout(3)).to eq 2
    end
  end

  describe '#favorite_opponent' do
    it 'can determine a team\'s favorite opponent' do
      expect(@stat_tracker3.favorite_opponent(5)).to eq('Houston Dynamo')
      expect(@stat_tracker3.favorite_opponent('5')).to eq('Houston Dynamo')
      expect(@stat_tracker3.favorite_opponent(53)).to eq('No favorite')
      expect(@stat_tracker3.favorite_opponent('53')).to eq('No favorite')
    end
  end

  describe '#rival' do
    it 'can determine a team\'s rival' do
      expect(@stat_tracker3.rival(5)).to eq('FC Dallas')
      expect(@stat_tracker3.rival('5')).to eq('FC Dallas')
      expect(@stat_tracker3.rival(53)).to eq('No rival')
      expect(@stat_tracker3.rival('53')).to eq('No rival')
    end
  end

  describe '#head_to_head' do
    it 'can return a hash of opponents and win percentages' do
      expect(@stat_tracker3.head_to_head(5)).to eq({"FC Dallas"=>0.25, "Houston Dynamo"=>1.0})
      expect(@stat_tracker3.head_to_head('5')).to eq({"FC Dallas"=>0.25, "Houston Dynamo"=>1.0})
    end
  end

  describe '#seasonal_summary' do
    it 'shows a hash that points to win%, total_goals, average_goals' do
      
      expect_hash = { 
      "20122013" => {
        :postseason=> {
          :average_goals_against=>0.48, 
          :average_goals_scored=>0.28, 
          :total_goals_against=>14, 
          :total_goals_scored=>8, 
          :win_percentage=>0.0
          }, 
          :regular_season=> {
            :average_goals_against=>0.0, 
            :average_goals_scored=>0.0, 
            :total_goals_against=>0, 
            :total_goals_scored=>0, 
            :win_percentage=>0.0
            }
          },
          "20132014" => {
            :postseason=> {
              :average_goals_against=>0.0, 
              :average_goals_scored=>0.0, 
              :total_goals_against=>0, 
              :total_goals_scored=>0, 
              :win_percentage=>0.0
              }, 
              :regular_season=> {
                :average_goals_against=>0.0, 
                :average_goals_scored=>0.0, 
                :total_goals_against=>0, 
                :total_goals_scored=>0, 
                :win_percentage=>0.0
                }
              }
            }
          binding.pry
      expect(@stat_tracker2.seasonal_summary("3")).to include(expect_hash)
    end
  end
end 
