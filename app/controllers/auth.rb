# coding: utf-8

Daphne.controllers :auth do
  get :auth, :map=>'/auth/:provider/callback' do
    auth    = request.env["omniauth.auth"]
    account = Account.first(:provider=>auth['provider'], :uid=>auth['uid']) ||
              Account.create_with_omniauth(auth)
    set_current_account(account)
    redirect "http://" + request.env["HTTP_HOST"] + url(:profile)
  end
end
