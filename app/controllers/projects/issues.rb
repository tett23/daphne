# coding: utf-8

Daphne.controllers :issues, :parent=>:projects do
  before do
    @project = Project.get(params[:project_id])
    error 404 if @project.nil?
    has_authority_or_403(@project, :view)
  end

  get :index do
    @issues = Issue.list(params[:project_id]).page(params[:page] || 1).per(ISSUE_PER_PAGE)
    @issue_close_count = Issue.aggrigate(@project.id, :close, current_account.id)
    @issue_new_count = Issue.aggrigate(@project.id , :new, current_account.id)

    add_breadcrumbs(@project.title, url(:projects, :show, :id=>@project.id))
    add_breadcrumbs('issues', url(:issues, :index, :project_id=>@project.id))

    render 'projects/issues/index'
  end
end
