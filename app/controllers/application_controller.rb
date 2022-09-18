class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionHelper
  before_action :login_check

  def pusher_client
    @pusher_client ||= Pusher::Client.new(
      app_id: '1478840',
      key: '0bb24337fdbe74754352',
      secret: 'bd1e8b5b4f73e6e42658',
      cluster: 'us2',
      encrypted: true
    )
  end
end

