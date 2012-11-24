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
end
