class ContinueSpeedTestJob < ApplicationJob
  def perform(speed_test_id, method)
    SpeedTest.find(speed_test_id).public_send method
  end
end
