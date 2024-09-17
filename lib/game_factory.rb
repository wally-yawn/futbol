class GameFactory
  attr_reader :games

  def initialize
    @games = []
  end
  def create_games(source)
    
    CSV.foreach(source, headers: true, header_converters: :symbol) do |row|
      @games << Game.new(row)
    end

  end

end
