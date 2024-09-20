class Team
  attr_reader :team_id, :franchise_id, :teamName, :abbreviation, :link

  def initialize(source)
    @team_id = source[:team_id]
    @franchise_id = source[:franchiseId]
    @teamName = source[:teamName]
    @abbreviation = source[:abbreviation]
    @link = source[:link]
  end
end
