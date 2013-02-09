# coding: utf-8

Daphne.helpers do
  def wiki_format(text)
    return '' if text.nil?

    text = RedCloth.new(text).to_html

    project_id = params[:project_id]
    text.gsub!(/\[\[(.+?)\]\]/) do |title|
      title.gsub!(/[\[\]]/, '')

      is_wiki_exist = Wiki.exist?(current_account.id, project_id, title)

      "<a href='/projects/#{project_id}/wiki/#{title}' class='#{'new' unless is_wiki_exist}'>#{title}</a>"
    end

    text
  end
end
