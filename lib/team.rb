class Team
  attr_reader :team_id, :franchise_id, :teamName, :abbreviation, :stadium, :link

  def initialize(source)
    @team_id = source[:team_id]
    @franchise_id = source[:franchiseId]
    @teamName = source[:teamName]
    @abbreviation = source[:abbreviation]
    @stadium = source[:Stadium]
    @link = source[:link]
  end
end