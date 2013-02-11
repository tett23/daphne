# coding: utf-8

Daphne.controllers :issues, :parent=>:projects do
  get :index do
    @project = Project.get(params[:project_id])
    @issues = Issue.list(current_account.id, :project_id=>params[:project_id])

    add_breadcrumbs(@project.title, url(:projects, :show, :id=>@project.id))
    add_breadcrumbs('issues', url(:issues, :index, :project_id=>@project.id))

    render 'projects/issues/index'
  end
end
