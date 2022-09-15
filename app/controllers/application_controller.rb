class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionHelper
  before_action :login_check
end
