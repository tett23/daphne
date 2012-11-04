# coding: utf-8

Daphne.controllers :sessions do
  get :sign_in do
    render 'session/sign_in'
  end

  get :destroy do
    set_current_account(nil)
    redirect url(:index)
  end
end
