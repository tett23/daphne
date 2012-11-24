# coding: utf-8

require './lib/twitter_keys'

class Daphne < Padrino::Application
  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl
  register OmniauthInitializer

  enable :authentication
  enable :store_location
  enable :sessions

  set :login_page, '/sessions/login'

  access_control.roles_for :any do |role|
    role.protect '/'
    role.allow '/sessions'
    role.allow '/auth'
  end

  access_control.roles_for :users do |role|
  end

  before do
    if login?
      @projects = Project.list(current.id)
    end
  end

  error 404 do
    render 'errors/404'
  end

  error 505 do
    render 'errors/505'
  end
end
