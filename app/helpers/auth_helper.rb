# coding: utf-8

Daphne.helpers do
  def has_authority?(item)
    return true unless item.attributes.key?(:account_id)

    item.account_id == current_account.id
  end

  def has_authority_or_403(item)
    error 403 unless has_authority?(item)
  end
end
