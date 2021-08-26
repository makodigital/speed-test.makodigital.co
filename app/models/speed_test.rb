class SpeedTest < ApplicationRecord
  validates_presence_of :email
  validates_presence_of :url
  validates :url, http_url: true

  def url=(value)
    return super unless value.present?

    return super if value.start_with?('http://') || value.start_with?('https://')

    super("http://#{value}")
  end

  def start
    return if gtmetrix_test_id

    response = execute("https://gtmetrix.com/api/2.0/tests", JSON.dump({
      "data" => {
        "type" => "test",
        "attributes" => {
          "url" => url,
          "adblock" => 1
        }
      }
    }))

    return unless response.kind_of? Net::HTTPSuccess

    res = JSON.parse(response.body)
    test_id = res.dig('data', 'id')
    update! gtmetrix_test_id: test_id if test_id.present?
  end

  def get_report_id
    return unless gtmetrix_test_id

    response = execute("https://gtmetrix.com/api/2.0/tests/#{gtmetrix_test_id}", nil, method: :get)

    return unless response.kind_of? Net::HTTPRedirection

    res = JSON.parse(response.body)
    report_id = res.dig('data', 'links', "report").split("/").last
    update! gtmetrix_report_id: report_id if report_id.present?
  end

  def report_url
    return gtmetrix_report_url if gtmetrix_report_url.present?
    return unless gtmetrix_test_id
    return unless gtmetrix_report_id

    response = execute("https://gtmetrix.com/api/2.0/reports/#{gtmetrix_report_id}", nil, method: :get)

    return unless response.kind_of? Net::HTTPSuccess

    res = JSON.parse(response.body)
    update! gtmetrix_report_url: res.dig("data", "links", "report_pdf")
  end

  def report
    return unless gtmetrix_test_id
    return unless gtmetrix_report_id

    response = execute(report_url, nil, method: :get)

    case response
    when Net::HTTPSuccess then
      update!(gtmetrix_report_data: response.body)
    when Net::HTTPRedirection then
      location = "https://gtmetrix.com#{response['location']}"
      warn "redirected to #{location}"
      redirect_response = execute(location, nil, method: :get)
      p redirect_response
      return unless redirect_response.kind_of? Net::HTTPSuccess
      update!(gtmetrix_report_data: redirect_response.body)
      # File.binwrite("thepdf.pdf", redirect_response.body)
    else
      # Prob some error
    end
  end

  private

  def execute(endpoint, body, method: :post)
    uri = URI.parse(endpoint)
    request = method == :post ? Net::HTTP::Post.new(uri) : Net::HTTP::Get.new(uri)
    request.basic_auth("0369426ab630d3914d706027a3d1051c", "")
    request.content_type = "application/vnd.api+json" if body
    request.body = body if body

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end

end
