class ApiController < ApplicationController
  respond_to :json

  def explore
    end_point = "#{DOORKEEPER_PROTECTED_ENDPOINT_PREFIX}/#{params[:api]}"
    @json = doorkeeper_access_token.get(end_point).parsed
    respond_with @json
  end
end
