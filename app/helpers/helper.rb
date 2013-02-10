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
    haml = <<EOS
%a{:href=>'#{url}', :class=>'btn #{option[:button_class]}', :'data-method'=>'#{option[:method].nil? ? :get : option[:method]}'}
  %i{:class=>'#{option[:icon]}'}
  #{str}
EOS

    Haml::Engine.new(haml).render
  end

  def breadcrumbs
    return '' if @breadcrumbs.nil?

    @breadcrumbs.map do |item|
      link_to(item[:title], item[:url])
    end.join('&nbsp;/&nbsp;')
  end

  def add_breadcrumbs(title, url)
    @breadcrumbs = [] if @breadcrumbs.nil?

    @breadcrumbs << {:title=>title, :url=>url}
  end

  def clear_breadcrumbs
    @breadcrumbs = []
  end
end
