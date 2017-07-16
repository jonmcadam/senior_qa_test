class Authenticate < Generic
  attr_reader :auth_token

  def login
    # use a single auth token for the entire framework
    # we can also configure this so that a new auth token
    # is generated for each feature file
    return self unless @auth_token.nil?

    @auth_token = eval(post(
      path: 'authenticate/api',
      body: {
        login_id: CREDS[:id],
        api_key: CREDS[:key]
      }
    ).body)[:auth_token]

    self
  end

  def end_session
    post(
      path: 'authenticate/close_session',
      headers: {
        'X-Auth-Token': @auth_token
      }
    )
  end

  def verify_auth_token
    debug_verify {
      raise 'Failed to retrieve auth token.' if @auth_token.nil?
    }
  end
end
