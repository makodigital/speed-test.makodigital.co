class SpeedTestsController < ApplicationController
  protect_from_forgery except: :show

  def new
    @speed_test = SpeedTest.new
  end

  def show
    @speed_test = SpeedTest.find(params[:id])

    @speed_test.continue_process

    respond_to do |format|
      format.html
      format.js
      format.pdf { send_data @speed_test.gtmetrix_report_data, filename: 'MAKO Quick Performance Report.pdf' }
    end
  end

  def create
    @speed_test = SpeedTest.new(speed_test_params)
    if @speed_test.save
      ContinueSpeedTestJob.perform_later(@speed_test.id, 'start')
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
