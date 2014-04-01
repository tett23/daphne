# coding: utf-8

Daphne.helpers do
  def has_authority?(project, privilege, account=nil)
    account ||= current_account
    return true if project_owner?(project, account)
    return true if Authority.allow_everyone_access?(project.id, privilege)

    privileges = Authority.account_privileges(project.id, account.id)
    return true if privileges.include?(:all)
    privileges.include?(privilege)
  end

  def project_owner?(project, account=nil)
    account ||= current_account

    return true unless project.attributes.key?(:account_id)
    project.account_id === account.id
  end

  def has_authority_or_403(project, authority, account=nil)
    error 403 if project.nil?
    error 403 unless has_authority?(project, authority, account)
  end
end
