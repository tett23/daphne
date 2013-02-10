# coding: utf-8

require 'yaml'

Color.all.destroy!
Color.repository.adapter.execute('ALTER TABLE colors AUTO_INCREMENT= 1')
YAML.load_file('./db/colors.yml').each do |color|
  Color.create(color)
end

IssueStatus.all.destroy!
IssueStatus.repository.adapter.execute('ALTER TABLE issue_statuses AUTO_INCREMENT = 1')
YAML.load_file('./db/issue_statuses.yml').each do |issue_status|
  IssueStatus.create(issue_status)
end

