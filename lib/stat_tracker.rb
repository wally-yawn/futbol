require_relative './helper_class'

class StatTracker
  attr_reader :game_teams_factory,
              :teams_factory,
              :game_factory,
              :all_games,
              :all_teams,
              :all_game_teams

  def initialize
      @game_teams_factory = GameTeamFactory.new
      @teams_factory = Teams_factory.new    
      @game_factory = GameFactory.new
      @all_games = []
      @all_teams = []
      @all_game_teams = []
  end

  def self.from_csv(source)
    stattracker = StatTracker.new

    source.each do |key, value|
        case key
        when :games
          stattracker.game_factory.create_games(value)
        when :teams
          stattracker.teams_factory.create_teams(value)
        when :game_teams
          stattracker.game_teams_factory.create_game_teams(value)
        end
      end

      stattracker.instance_variable_set(:@all_games, stattracker.game_factory.games)
      stattracker.instance_variable_set(:@all_teams, stattracker.teams_factory.teams)
      stattracker.instance_variable_set(:@all_game_teams, stattracker.game_teams_factory.game_teams)

    stattracker
  end

  def percentage_home_wins
    total_games = @games.length
    home_wins = @games.count { |game| game.home_goals > game.away_goals }
          
    percentage = (home_wins.to_f / total_games) * 100
    percentage.round(2)
  end

  def highest_total_score
    scores = @all_games.map do |game|
      game.home_goals + game.away_goals
    end
    scores.max
  end

  def lowest_total_score
    scores = @all_games.map do |game|
      game.home_goals + game.away_goals
    end
    scores.min
  end

end