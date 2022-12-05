class HealthController < ApplicationController
  def index
    response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    render json: { status: 'ok' }, status: 200
  end
end