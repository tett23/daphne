# coding: utf-8

Daphne.helpers do
  def wiki_format(text)
    RedCloth.new(text).to_html.split("\n")
  end
end
