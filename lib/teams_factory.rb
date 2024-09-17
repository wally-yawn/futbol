require 'CSV'
require_relative 'team'

class Teams_factory
  attr_reader :teams
  def initialize
    @teams = []
  end

  def create_teams(file_path)

    custom_header_converter = lambda do |header|
      header.to_sym
    end

    CSV.foreach(file_path, headers:true, header_converters: custom_header_converter) do |row|

      team = Team.new(row)
      @teams << team
    end
  end
end