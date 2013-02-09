# Helper methods defined here can be accessed in any controller or view in the application

Daphne.helpers do
  def project_nav
    if !@project.nil?
      return partial 'parts/project_nav', :locals=>{:project=>@project}
    end
    if !@issue.nil? && !@issue.project.nil?
      return partial 'parts/project_nav', :locals=>{:project=>@issue.project}
    end
    if !@wiki.nil? && !@wiki.project.nil?
      return partial 'parts/project_nav', :locals=>{:project=>@wiki.project}
    end

    ''
  end
end
