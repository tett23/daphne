# Helper methods defined here can be accessed in any controller or view in the application

Daphne.helpers do
  def project_nav
    project = get_project()
    return partial 'parts/project_nav', :locals=>{:project=>project} unless project.nil?

    ''
  end

  def get_project
    project = nil
    project = @project if !@project.nil? && !@project.id.nil?
    project = @issue.project if !@issue.nil? && !@issue.project.nil?
    project = @wiki.project if !@wiki.nil? && !@wiki.project.nil?

    project
  end

  def concern_projects
    Project.list(current_account.id).to_a + Authority.concerned(current_account.id, [:all, :view]).map do |authority|
      authority.project
    end.to_a.uniq
  end
end
