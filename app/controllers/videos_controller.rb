class VideosController < ApplicationController
  protect_from_forgery with: :null_session # Use null session to handle CSRF protection

  def token
    # Get the username from the request
    @username = params['username']

    # Handle error if no username was passed into the request
    render json: { status: 400, error: 'No username in request' } if @username.nil?

    twilio_account_sid = ENV['TWILIO_ACCOUNT_SID']
    twilio_api_key_sid = ENV['TWILIO_API_KEY_SID']
    twilio_api_key_secret = ENV['TWILIO_API_KEY_SECRET']

    # Create an access token
    token = Twilio::JWT::AccessToken.new(twilio_account_sid, twilio_api_key_sid, twilio_api_key_secret, [], identity: @username)

    # Create Video grant for your token
    grant = Twilio::JWT::AccessToken::VideoGrant.new
    grant.room = 'My Video Room'
    token.add_grant(grant)

    # Generate and return the token as a JSON response
    render json: { status: 200, token: token.to_jwt }
  end
end
