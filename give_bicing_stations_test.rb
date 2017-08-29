require 'test/unit'
require 'mocha/test_unit'
require 'pp'
require_relative 'helpers/bicing_stations'
require_relative 'helpers/bot_helper'
require_relative 'data/location'
require 'telegram/bot'



class GiveBicingStationsTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @biking_stations = BicingStations.new

    @location = Location.new("{:latitude =>41.493875,:longitude => 2.074632, :a =>'p'}")

    @inlineQuery_drop = Telegram::Bot::Types::InlineQuery.new(
        id: 1,
        from: Telegram::Bot::Types::User.new(id: 1, first_name: 'Edu'),
        location: Telegram::Bot::Types::Location.new(longitude: 2.074632, latitude: 41.493875),
        query: 'drop',
        offset: ''
    )

    @inlineQuery_pickup = Telegram::Bot::Types::InlineQuery.new(
        id: 1,
        from: Telegram::Bot::Types::User.new(id: 1, first_name: 'Edu'),
        location: Telegram::Bot::Types::Location.new(longitude: 2.074632, latitude: 41.493875),
        query: 'Pickup',
        offset: ''
    )
  end

  def  test_network_call_retrun_an_error_code
    mocked_element = BicingStations.new
    mocked_element.stubs(:nearby_network).returns('hj')
    assert_raise StandardError do
      pp mocked_element.closest_station(@location)
    end
  end

  def test_closest_station_for_a_given_location
    assert_equal(41.42968,@biking_stations.closest_station(@location)[0].latitude)

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

  def test_bot_helper_get_sations_from_inlineQuery_drop
    assert_not_nil (pp BotHelper.get_stations_inline(@inlineQuery_drop))
  end

  def test_bot_helper_get_stations_from_inlineQuery_pickup
    assert_not_nil(pp BotHelper.get_stations_inline(@inlineQuery_pickup))
  end

  def test_bot_helper_inline_result_multiple_stations
    result = BotHelper.get_stations_inline(@inlineQuery_pickup, 5)
    arr = BotHelper.inline_result(result)
    assert_not_nil(Array.try_convert(arr))
    assert_equal('1',arr[0].id)
    assert_equal('2',arr[1].id)
  end

  def teardown
    # Do nothing
  end

end
