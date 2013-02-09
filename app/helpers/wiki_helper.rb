# coding: utf-8

Daphne.helpers do
  def wiki_format(text)
    return '' if text.nil?

    text = RedCloth.new(text).to_html

    project_id = params[:project_id]
    text.gsub!(/\[\[(.+?)\]\]/, '<a href="/projects/'+project_id+'/wiki/\1">\1</a>')

    text
  end
end
