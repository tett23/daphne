# coding: utf-8

require './lib/twitter_keys'
require 'kaminari/sinatra'

ISSUE_PER_PAGE = 50

class Daphne < Padrino::Application
  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl
  register OmniauthInitializer
  register Kaminari::Helpers::SinatraHelpers


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
    role.allow '/sessions'
  end

  before do
    if logged_in?
      @projects = concern_projects
      @select_list = Project.select_list(current_account.id)
    end

    add_breadcrumbs('daphne', '/')
  end

  error 403 do
    render 'errors/403'
  end

  error 404 do
    render 'errors/404'
  end

  error 505 do
    render 'errors/505'
  end
end
