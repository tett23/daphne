# coding: utf-8

Daphne.helpers do
  def wiki_format(text)
    return '' if text.nil?

    RedCloth.new(text).to_html
  end
end
