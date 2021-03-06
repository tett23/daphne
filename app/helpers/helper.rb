# coding: utf-8

Daphne.helpers do
  def color(item)
    case item
    when Issue
      unless item.project.nil?
        unless item.project.color.nil?
          return item.project.color.color_code
        end
      end
    when Project
      unless item.color.nil?
        return item.color.color_code
      end
    else
      return nil
    end

    return nil
  end

  def button_link(str, url, option={})
    anchor_options = {
      :href          => url,
      :class         => "btn #{option[:button_class]}",
      :'data-method' => option[:method].nil? ? nil : option[:method],
      :role          => option[:role].nil? ? nil : option[:role],
      :'data-toggle' => option[:'data-toggle'].nil? ? nil : option[:'data-toggle']
    }

    haml = <<EOS
%a{#{anchor_options}}
  %i{:class=>'#{option[:icon]}'}
  #{str}
EOS

    Haml::Engine.new(haml).render
  end

  def breadcrumbs
    return '' if @breadcrumbs.nil?

    haml = <<EOS
%ul.breadcrumb
  -breadcrumbs.each_with_index do |item, i|
    %li
      =link_to item[:title], item[:url]
      -if breadcrumbs.size-1 != i
        %span.divider /
EOS

    Haml::Engine.new(haml).render(self, :breadcrumbs=>@breadcrumbs)
  end

  def add_breadcrumbs(title, url)
    @breadcrumbs = [] if @breadcrumbs.nil?

    @breadcrumbs << {:title=>title, :url=>url}
  end

  def clear_breadcrumbs
    @breadcrumbs = []
  end

  def date_diff(date1, date2)
    diff = (date1 - date2).to_i rescue nil

    return nil if diff.nil?
    return '今日' if diff == 0
    diff.to_s+'日前'
  end
end
