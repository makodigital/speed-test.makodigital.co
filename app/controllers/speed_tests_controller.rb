class SpeedTestsController < ApplicationController
  def new
    @speed_test = SpeedTest.new
  end

  def create
    @speed_test = SpeedTest.new(speed_test_params)
    if @speed_test.save
      render
    else
      render 'error'
    end
  end

  private

  def speed_test_params
    params.require(:speed_test).permit(:url, :email)
  end
end
