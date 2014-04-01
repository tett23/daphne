#coding: utf-8

Daphne.helpers do
  def show_issue_schedule(issue)
    return '期限なし' if issue.scheduled_on.blank?

    issue.scheduled_on.strftime('%Y-%m-%d(%a)')
  end
end
