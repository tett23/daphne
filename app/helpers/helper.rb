# coding: utf-8

Daphne.helpers do
  def login?
    !current_account.nil?
  end
end
