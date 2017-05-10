require 'test/unit'
require 'mocha/test_unit'
require 'pp'
require_relative 'bicing_stations'
#require_relative'bot_bicing_gram'

class GiveBicingStationsTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @biking_stations = BicingStations.new
  end

  def  test_network_call_retrun_an_error_code
    mocked_element = BicingStations.new
    mocked_element.stubs(:nearby_network).returns('hj')
    assert_raise StandardError do
      pp mocked_element.closest_station([41.493875,2.074632])
    end
  end

  def test_closest_station_for_a_given_location
    assert_not_nil( pp @biking_stations.closest_station([41.493875,2.074632]))
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

  def teardown
    # Do nothing
  end

end
