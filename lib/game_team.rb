class GameTeam
  attr_reader :game_id, :team_id, :hoa, :result, :settled_in,
              :head_coach, :goals, :shots, :tackles, :pim,
              :powerPlayOpportunities, :powerPlayGoals, :faceOffWinPercentage,
              :giveaways, :takeaways

  def initialize(game_team)
    @game_id = game_team[:game_id]
    @team_id = game_team[:team_id]
    @hoa = game_team[:HoA]
    @result = game_team[:result]
    @settled_in = game_team[:settled_in]
    @head_coach = game_team[:head_coach]
    @goals = game_team[:goals].to_i
    @shots = game_team[:shots].to_i
    @tackles = game_team[:tackles].to_i
    @pim = game_team[:pim].to_i
    @powerPlayOpportunities = game_team[:powerPlayOpportunities].to_i
    @powerPlayGoals = game_team[:powerPlayGoals].to_i
    @faceOffWinPercentage = game_team[:faceOffWinPercentage].to_f
    @giveaways = game_team[:giveaways].to_i
    @takeaways = game_team[:takeaways].to_i
  end
end
