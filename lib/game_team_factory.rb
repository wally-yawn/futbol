require 'CSV'
require './lib/game_team'

class GameTeamFactory
  attr_reader :game_teams

  def initialize
    @game_teams = []
  end

  def create_game_teams(file_path)
    custom_header_converter = lambda do |header|
      header.to_sym
    end

    CSV.foreach(file_path, headers: true, header_converters: custom_header_converter) do |row|
      @game_teams << GameTeam.new(row)
    end
  end
end
