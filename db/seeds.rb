# coding: utf-8

require 'yaml'

Color.all.destroy!
Color.repository.adapter.execute('update sqlite_sequence set seq=0 where name="colors"')
YAML.load_file('./db/colors.yml').each do |color|
  Color.create(color)
end
