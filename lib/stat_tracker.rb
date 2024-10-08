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
    home_wins = @all_games.count {|game| game.home_goals > game.away_goals}

    (home_wins.to_f / total_games).round(2)
  end

  def count_of_all_goals
    all_goals = 0
    @all_games.each do |game|
      game_goals = game.away_goals.to_i + game.home_goals.to_i
      all_goals += game_goals
    end
    all_goals
  end

  def percentage_visitor_wins
    visitor_wins = @all_games.count {|game| game.away_goals > game.home_goals}

    (visitor_wins.to_f / total_games).round(2)
  end

  def percentage_ties
    ties = @all_games.count {|game| game.away_goals == game.home_goals}

    (ties.to_f / total_games).round(2)
  end

  def best_offense
    team_goals = {}
    team_games = {}

    @all_game_teams.each do |game_team|
      team_id = game_team.team_id
      goals = game_team.goals.to_i

      team_goals[team_id] ||= 0
      team_goals[team_id] += goals

      team_games[team_id] ||= 0
      team_games[team_id] += 1
    end

    team_averages = team_goals.map do |team_id, total_goals|
      games_played = team_games[team_id]
      average_goals = total_goals.to_f / games_played
      [team_id, average_goals]
    end

    best_team_id = team_averages.max_by { |_,avg| avg }.first
    best_team = @all_teams.find {|team| team.team_id == best_team_id}

    best_team.teamName
  end

  def worst_offense
    team_goals = {}
    team_games = {}

    @all_game_teams.each do |game_team|
      team_id = game_team.team_id
      goals = game_team.goals.to_i

      team_goals[team_id] ||= 0
      team_goals[team_id] += goals

      team_games[team_id] ||= 0
      team_games[team_id] += 1
      end

      team_averages = team_goals.map do |team_id, total_goals|
        games_played = team_games[team_id]
        average_goals = total_goals.to_f / games_played
        [team_id, average_goals]
      end

      worst_team_id = team_averages.min_by { |_,avg| avg }.first
      worst_team = @all_teams.find {|team| team.team_id == worst_team_id}

      worst_team.teamName
  end

  def average_goals_per_game
    (count_of_all_goals / @all_games.count.to_f).round(2)
  end

  def average_goals_by_season
    season_games = {}

    get_seasons.each do |season|
      season_games[season] = games_by_season(season)
    end

    season_avg = {}

    season_games.each do |season, games|
      season_avg[season] = get_avg_goals(games)
    end
    season_avg
  end

  def games_by_season(season)
    @all_games.select do |game|
      game.season == season
    end
  end

  def get_seasons
    seasons = []
    @all_games.each do |game|
      seasons << game.season unless seasons.include?(game.season)
    end
    seasons
  end

  def get_games(team_id, hoa)
    no_games = [0] # only needed if there are no matching games
    games = []

    games = case hoa
              when :home
                @all_games.select do |game|
                  game.home_team_id.to_i == team_id
                end
              when :away
                @all_games.select do |game|
                  game.away_team_id.to_i == team_id
                end
              end

    return no_games unless games
    games
  end

  def get_avg_goals(games)
    goals = 0
    games.each do |game|
      goals += game.away_goals + game.home_goals
    end
    (goals.to_f / games.count).round(2)
  end

  def get_scores(team_id, hoa = :both, season = :all)
    no_goals = [0] # only needed if there are no goals
    team_id = team_id.to_i # team_id can be provided as int or str
    goals = []

    case hoa
      when :away
        get_games(team_id, :away).each do |game|
          goals << game.away_goals
        end
      when :home
        get_games(team_id, :home).each do |game|
          goals << game.home_goals
        end
      else # :both
        get_games(team_id, :home).each do |game|
          goals << game.home_goals
        end
        get_games(team_id, :away).each do |game|
          goals << game.away_goals
        end
      end

    return no_goals unless goals.any?
    goals
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

  def total_games
    @all_games.length
  end

  def scoring_averages(hoa, high_or_low)
    @all_teams.send(high_or_low) do |team|
      scores = get_scores(team.team_id, hoa).sum
      away_games_count = get_games(team.team_id.to_i, hoa).count
      scores.to_f / away_games_count.to_f
    end.teamName
  end

  def highest_scoring_visitor
    scoring_averages(:away, :max_by)
  end

  def highest_scoring_home_team
    scoring_averages(:home, :max_by)
  end

  def lowest_scoring_visitor
    scoring_averages(:away, :min_by)
  end

  def lowest_scoring_home_team
    scoring_averages(:home, :min_by)
  end

  def coach_win_percentages(season)
    coach_games = Hash.new { |hash, key| hash[key] = { wins: 0, games: 0}}
    @all_game_teams.each do |game_team|
      game = @all_games.find { |g| g.game_id == game_team.game_id }
      next if season && game.season != season.to_s
      coach = game_team.head_coach
      coach_games[coach][:games] += 1
      coach_games[coach][:wins] += 1 if game_team.result == "WIN"
    end
    coach_games.transform_values do |stats| 
      games = stats[:games]
      games > 0 ? ((stats[:wins].to_f / games) * 100).round : 0
    end
  end

  def winningest_coach(season = nil)
    coach_win_percentages(season).max_by { |coach, win_percentage| win_percentage}.first
  end

  def worst_coach(season = nil)
    coach_win_percentages(season).min_by { |coach, win_percentage| win_percentage}.first
  end

  def count_of_games_by_season
    count_of_games_by_season = Hash.new(0)
    @all_games.each do |game|
      season = game.season
      count_of_games_by_season[season] += 1
    end
    count_of_games_by_season
  end

  def team_shot_goal_ratios(season = nil)
    team_ratios = Hash.new { |hash, key| hash[key] = { goals: 0, shots: 0 } }

    @all_game_teams.each do |game_team|
      game = @all_games.find { |g| g.game_id == game_team.game_id }
      next if season && game.season != season.to_s
      team_id = game_team.team_id
      team_ratios[team_id][:goals] += game_team.goals.to_i
      team_ratios[team_id][:shots] += game_team.shots.to_i
    end

    @all_teams.each_with_object({}) do |team, result|
      team_id = team.team_id
      goals = team_ratios[team_id][:goals]
      shots = team_ratios[team_id][:shots]
      result[team.teamName] = shots > 0 ? (goals.to_f / shots) : 0
    end
  end

  def most_accurate_team(season = nil)
    team_shot_goal_ratios(season).max_by {|team_name, ratio| ratio }.first
  end

  def least_accurate_team(season = nil)
    team_shot_goal_ratios(season).reject { |team_name, ratio| ratio == 0 }.min_by { |team_name, ratio| ratio }.first
  end

  def team_tackle_total(season = nil)
    team_tackles = Hash.new(0)

    @all_game_teams.each do |game_team|
      game = @all_games.find { |g| g.game_id == game_team.game_id }
      next if season && game.season != season.to_s

      team_tackles[game_team.team_id] += game_team.tackles.to_i
    end
      @all_teams.each_with_object({}) do |team, result|
        team_id = team.team_id
        result[team.teamName] = team_tackles[team_id]
      end
  end

  def count_of_teams
    @all_teams.length
  end

  def most_tackles(season = nil)
    team_tackle_total(season).max_by { |team_name, tackles| tackles}.first
  end

  def fewest_tackles(season = nil)
    team_tackle_total(season).reject { |team_name, tackles| tackles == 0 }.min_by { |team_name, tackles| tackles }.first
  end

  def team_info(team_id)
    team = all_teams.find do |team|
      team.team_id == team_id.to_s
    end
    team_info = {
      'team_id' => team.team_id,
      'franchise_id' => team.franchise_id,
      'team_name' => team.teamName,
      'abbreviation' => team.abbreviation,
      'link' => team.link
    }
  end
  
  def average_win_percentage(team_id)
    wins = 0
    games = 0
    @all_games.count do |game|
        if team_id.to_s == game.home_team_id
          games += 1
          wins += 1 if game.home_goals > game.away_goals
        elsif team_id.to_s == game.away_team_id
          games += 1
          wins += 1 if game.away_goals > game.home_goals
        end
      end
    wins > 0 ? ((wins.to_f / games)).to_f.round(2) : 0
  end

  def most_goals_scored(team_id)
    most_goals = 0
    all_game_teams.each do |game_team|
      if game_team.team_id == team_id.to_s && game_team.goals > most_goals
        most_goals = game_team.goals
      end
    end
    most_goals
  end

  def fewest_goals_scored(team_id)
    fewest_goals = Float::INFINITY
    all_game_teams.each do |game_team|
      if game_team.team_id == team_id.to_s && game_team.goals < fewest_goals
        fewest_goals = game_team.goals
      end
    end
    fewest_goals
  end
  
  def worst_loss(team_id) 
    worst_loss_margin = []

    @all_games.each do |game|
      if team_id.to_s == game.home_team_id && game.home_goals < game.away_goals
        worst_loss_margin << game.away_goals - game.home_goals
      elsif team_id.to_s == game.away_team_id && game.away_goals < game.home_goals
        worst_loss_margin << game.home_goals - game.away_goals
      end
    end
    worst_loss_margin.max == nil ?  0 : worst_loss_margin.max
  end
  
  def best_season(team_id)
    seasons_wins = {}
    season_games = {}
  
    get_seasons.each do |season|
      season_games[season] ||= 0
      seasons_wins[season] ||= 0
    end

    @all_games.each do |game|
        season = game.season
        if team_id.to_s == game.home_team_id
            seasons_wins[season] += 1 if game.home_goals > game.away_goals
            season_games[season] += 1
        elsif team_id.to_s == game.away_team_id
            seasons_wins[season] += 1 if game.away_goals > game.home_goals 
            season_games[season] += 1
        end
      end
 
    win_percentages = seasons_wins.map do |season, wins|
                        [season, wins.to_f / season_games[season]]
                      end.to_h
    win_percentages.max_by{ |_,  percentage| percentage}&.first
  end

  def worst_season(team_id)
    seasons_wins = {}
    season_games = {}
  
    get_seasons.each do |season|
      season_games[season] ||= 0
      seasons_wins[season] ||= 0
    end

    @all_games.each do |game|
        season = game.season
        if team_id.to_s == game.home_team_id
            seasons_wins[season] += 1 if game.home_goals > game.away_goals
            season_games[season] += 1
        elsif team_id.to_s == game.away_team_id
            seasons_wins[season] += 1 if game.away_goals > game.home_goals 
            season_games[season] += 1
        end
      end
 
    win_percentages = seasons_wins.map do |season, wins|
                        [season, wins.to_f / season_games[season]]
                      end.to_h
    win_percentages.min_by{ |_,  percentage| percentage}&.first
  end

  def biggest_team_blowout(team_id)
    team_games = get_games(team_id, :home) + get_games(team_id, :away)
    biggest_blowout = 0

    team_games.each do |game|
      diff = (game.home_goals - game.away_goals).abs
      biggest_blowout = diff if diff > biggest_blowout
    end
    biggest_blowout  
  end

  
    def head_to_head(team_id)
    home_team_games = get_games(team_id.to_i, :home)
    away_team_games = get_games(team_id.to_i, :away)
    opponents = []
    head_to_head_hash = {}

    home_team_games.each do |game|
      if !opponents.include?(game.away_team_id)
        opponents << game.away_team_id
      end
    end
 
    away_team_games.each do |game|
      if !opponents.include?(game.home_team_id)
        opponents << game.home_team_id
      end
    end

    opponents.each do |opponent|
      wins = 0
      losses = 0
      games = 0
      home_team_games.each do |game|
        if game.away_team_id.to_s == opponent.to_s
          games += 1
          if game.home_goals  > game.away_goals
            wins += 1
          elsif game.home_goals < game.away_goals
            losses += 1
          end
        end
      end
      away_team_games.each do |game|
        if game.home_team_id.to_s == opponent.to_s
          games += 1
          if game.home_goals  > game.away_goals
            losses += 1
          elsif game.home_goals < game.away_goals
            wins += 1
          end
        end
      end

      team_name = all_teams.find do |team|
        opponent == team.team_id.to_s
      end.teamName
      win_percentage = wins.to_f / games.to_f
      head_to_head_hash[team_name] = win_percentage
    end
    head_to_head_hash
  end

  def favorite_opponent(team_id)
    head_to_head_percentages = head_to_head(team_id)
    if head_to_head_percentages.length > 0
      head_to_head_percentages.max_by {|opponent, win_percentage| win_percentage}[0]
    else
      "No favorite"
    end
  end

  def rival(team_id)
    head_to_head_percentages = head_to_head(team_id)
    if head_to_head_percentages.length > 0
      head_to_head_percentages.min_by {|opponent, win_percentage| win_percentage}[0]
    else
      "No rival"
    end
  end

  def seasonal_summary(team_id)
    seasons = {}

    @all_games.each do |game|
      season = game.season
      type = game.type == "Postseason" ? :postseason : :regular_season

      seasons[season] ||= {
        regular_season: { win_percentage: 0.0, total_goals_scored: 0, total_goals_against: 0, average_goals_scored: 0.0, average_goals_against: 0.0, games_played: 0, wins: 0  },
        postseason: { win_percentage: 0.0, total_goals_scored: 0, total_goals_against: 0, average_goals_scored: 0.0, average_goals_against: 0.0, games_played: 0, wins: 0  }
        }
        current_season = seasons[season][type]
        current_season[:games_played] += 1

        if game.home_team_id.to_s == team_id.to_s
          current_season[:total_goals_scored] += game.home_goals.to_i
          current_season[:total_goals_against] += game.away_goals.to_i
          current_season[:wins] += 1 if game.home_goals.to_i > game.away_goals.to_i
        elsif game.away_team_id.to_s == team_id.to_s
          current_season[:total_goals_scored] += game.away_goals.to_i
          current_season[:total_goals_against] += game.home_goals.to_i
          current_season[:wins] += 1 if game.away_goals.to_i > game.home_goals.to_i
        end
    end
    
    seasons.each do |season, types|
     types.each do |type, stats|
        total_games = stats[:games_played]
        if total_games > 0
          stats[:win_percentage] = (stats[:wins].to_f / total_games).round(2)
          stats[:average_goals_scored] = (stats[:total_goals_scored].to_f / total_games).round(2)
          stats[:average_goals_against] = (stats[:total_goals_against].to_f / total_games).round(2)
        else
          stats[:win_percentage] = 0.0
          stats[:average_goals_scored] = 0.0
          stats[:average_goals_against] = 0.0
        end
        stats.delete(:games_played)
        stats.delete(:wins)
      end
    end
    seasons
  end
end
