class TrackerAPI

  def initialize
    @connection = Faraday.new(:url => 'https://www.pivotaltracker.com')
  end

  def projects(token)
    return [] if token.nil?

    response = @connection.get do |request|
      request.url "/services/v5/projects"
      request.headers['Content-Type'] = 'application/json'
      request.headers['X-TrackerToken'] = token
    end

    if response.success?
      JSON.parse(response.body, symbolize_names: true)
    end
  end

  def project(project_id, token)
    return [] if token.nil?

    response = @connection.get do |request|
      request.url "/services/v5/projects/#{project_id}"
      request.headers['Content-Type'] = 'application/json'
      request.headers['X-TrackerToken'] = token
    end

    if response.success?
      JSON.parse(response.body, symbolize_names: true)
    end
  end

  def stories(project_id, token)
    return [] if token.nil?

    response = @connection.get do |request|
      request.url "/services/v5/projects/#{project_id}/stories?limit=500"
      request.headers['Content-Type'] = 'application/json'
      request.headers['X-TrackerToken'] = token
    end

    if response.success?
      JSON.parse(response.body, symbolize_names: true)
    end
  end

end
