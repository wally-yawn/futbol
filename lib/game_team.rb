class GameTeam
  attr_reader :game_id, :team_id, :hoa, :result, :settled_in,
              :head_coach, :goals, :shots, :tackles, :pim,
              :powerPlayOpportunities, :powerPlayGoals, :faceOffWinPercentage,
              :giveaways, :takeaways

  def initialize(game_team)
    @game_id = game_team[:game_id]
    @team_id = game_team[:team_id]
    @hoa = game_team[:hoa]
    @result = game_team[:result]
    @settled_in = game_team[:settled_in]
    @head_coach = game_team[:head_coach]
    @goals = game_team[:goals].to_i
    @shots = game_team[:shots].to_i
    @tackles = game_team[:tackles].to_i
  end
end
