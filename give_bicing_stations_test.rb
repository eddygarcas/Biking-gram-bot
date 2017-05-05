require 'test/unit'
require 'pp'
require_relative 'bicing_stations'
#require_relative 'bot_bicing_gram'

class GiveBicingStationsTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @biking_stations = BicingStations.new
  end

  def  test_the_closest_bicing_stations
    assert_not_nil(pp @biking_stations.closest_station([41.493875,2.074632]))
  end

  def test_closest_network
    assert_not_nil(pp @biking_stations.nearby_network([41.493875,2.074632]))
  end

  def test_null_location_argument
    assert_raise ArgumentError do
      @biking_stations.closest_station([])
    end
  end

  def test_null_location_argument_looking_for_networks
    assert_raise ArgumentError do
      @biking_stations.nearby_network([])
    end
  end
  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

end
