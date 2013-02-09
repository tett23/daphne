# coding: utf-8

require 'yaml'

Color.all.destroy!
Color.repository.adapter.execute('ALTER TABLE colors AUTO_INCREMENT= 1')
YAML.load_file('./db/colors.yml').each do |color|
  Color.create(color)
end
