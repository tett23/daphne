# coding: utf-8

Daphne.helpers do
  def login?
    !current_account.nil?

    !session[:account_id].nil?
  end

  def current
    current_account.first
  end
end
