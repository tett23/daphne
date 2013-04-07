# coding: utf-8

Daphne.helpers do
  def wiki_format(text)
    return '' if text.blank?

    text = RedCloth.new(text).to_html

    pre_mode = false
    project_id = params[:project_id]
    text.lines.to_a.map do |line|
      line.gsub!(/([^><"]?)(https?:\/\/.+?)([<\s$])/, '\1<a href="\2">\2</a>\3') unless line.match(/<a\s.+/)

      pre_mode = true if line =~ /<\s*pre\s*>/
      pre_mode = false if line =~ /<\s*\/\s*pre\s*>/

      unless pre_mode
        line = line.gsub(/\[\[(.+?)\]\]/) do |title|
          title.gsub!(/[\[\]]/, '')

          is_wiki_exist = Wiki.exist?(current_account.id, project_id, title)

          "<a href='/projects/#{project_id}/wiki/#{title}' class='#{'new' unless is_wiki_exist}'>#{title}</a>"
        end
      end

      line
    end.join()
  end
end
