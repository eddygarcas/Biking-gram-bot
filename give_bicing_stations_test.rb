require 'test/unit'
require 'pp'
require_relative 'bicing_stations'
require_relative 'bot_bicing_gram'

class GiveBicingStationsTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    #
#    GiveBicingSations.nearby_station
    @stations = BicingStations.new

  end


  def test_xclosest_bicing_stations
    BotBicingGram.new
    pp @stations.closest_station([41.493875,2.074632])
    # @latitude = 41.493875
    # @longitude = 2.074632

  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

end