class Game
  attr_reader :game_id, :season, :type, :date_time, :away_team_id, :home_team_id, 
              :away_goals, :home_goals, :venue, :venue_link

  def initialize(source)
    @game_id = source[:game_id]
    @season = source[:season]
    @type = source[:type]
    @date_time = source[:date_time]
    @away_team_id = source[:away_team_id]
    @home_team_id = source[:home_team_id]
    @away_goals = source[:away_goals]
    @home_goals = source[:home_goals]
    @venue = source[:venue]
    @venue_link = source[:venue_link]
  end
end
