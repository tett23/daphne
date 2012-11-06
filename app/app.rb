# coding: utf-8

require './lib/twitter_keys'

class Daphne < Padrino::Application
  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl
  register OmniauthInitializer

  enable :sessions

  set :login_page, '/sessions/login'

  access_control.roles_for :any do |role|
  end

  access_control.roles_for :users do |role|
  end

  before do
    if login?
      @projects = Project.all
    end
  end

  error 404 do
    render 'errors/404'
  end

  error 505 do
    render 'errors/505'
  end
end
