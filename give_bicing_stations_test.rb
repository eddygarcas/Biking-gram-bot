require 'test/unit'
require 'pp'
require_relative 'bicing_stations'
require_relative 'bot_bicing_gram'

class GiveBicingStationsTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
   
    @stations = BicingStations.new

  end


  def  test_xclosest_bicing_stations
    pp @stations.closest_station([41.493875,2.074632])
  end

  def test_closest_network
     pp @stations.nearby_network([41.493875,2.074632])
   end
  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

end
