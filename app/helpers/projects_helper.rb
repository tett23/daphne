# Helper methods defined here can be accessed in any controller or view in the application

Daphne.helpers do
  def project_nav
    project = get_project()
    return partial 'parts/project_nav', :locals=>{:project=>project} unless project.nil?

    ''
  end

  def get_project
    if !@project.nil? && !@project.id.nil?
      return @project
    end
    if !@issue.nil? && !@issue.project.nil?
      return @issue.project
    end
    if !@wiki.nil? && !@wiki.project.nil?
      return @wiki.project
    end

    nil
  end
end
