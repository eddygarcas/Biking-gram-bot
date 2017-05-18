require 'test/unit'
require 'mocha/test_unit'
require 'pp'
require_relative 'bicing_stations'
require_relative 'helpers/bot_helper'
require_relative 'data/location'
#require_relative'bot_bicing_gram'

class GiveBicingStationsTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @biking_stations = BicingStations.new

    @location = Location.new("{:latitude =>41.493875,:longitude => 2.074632, :a =>'p'}")
  end

  def  test_network_call_retrun_an_error_code
    mocked_element = BicingStations.new
    mocked_element.stubs(:nearby_network).returns('hj')
    assert_raise StandardError do
      pp mocked_element.closest_station(@location)
    end
  end

  def test_closest_station_for_a_given_location
    assert_equal(41.437053,@biking_stations.closest_station(@location)[0].latitude)

    assert_not_nil( pp @biking_stations.closest_station(@location))
  end

  def test_closest_network
    assert_not_nil(pp @biking_stations.nearby_network(@location))
    assert_equal("bicing",@biking_stations.nearby_network(@location))
  end

  def test_null_location_argument
    assert_raise ArgumentError do
      @biking_stations.closest_station(nil)
    end
  end

  def test_null_location_argument_looking_for_networks
    assert_raise ArgumentError do
      @biking_stations.nearby_network(nil)
    end
  end

  def test_bot_helper_get_stations

    assert_not_nil( pp BotHelper.get_stations("{:latitude =>41.493875,:longitude => 2.074632, :a =>'p'}"))

  end

  def teardown
    # Do nothing
  end

end
