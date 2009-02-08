class AdminController < ApplicationController
  require_role 'admin'

  def index
    @links = %w(users translations) # sources removed as non-working
  end
end
