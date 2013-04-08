# coding: utf-8

Daphne.controllers :issues, :parent=>:projects do
  get :index do
    @project = Project.get(params[:project_id])
    return error 404 if @project.nil?
    has_authority_or_403(@project)

    @issues = Issue.list(current_account.id, :project_id=>params[:project_id]).page(params[:page] || 1).per(ISSUE_PER_PAGE)
    @issue_close_count = Issue.aggrigate(current_account.id, :close, params[:project_id])
    @issue_new_count = Issue.aggrigate(current_account.id, :new, params[:project_id])

    add_breadcrumbs(@project.title, url(:projects, :show, :id=>@project.id))
    add_breadcrumbs('issues', url(:issues, :index, :project_id=>@project.id))

    render 'projects/issues/index'
  end
end
