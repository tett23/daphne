#coding: utf-8

Daphne.helpers do
  def show_issue_schedule(issue)
    return '期限なし' if issue.scheduled_on.blank?

    show_date(issue.scheduled_on)
  end
end
