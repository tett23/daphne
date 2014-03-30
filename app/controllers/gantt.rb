# coding: utf-8

Daphne.controllers :gantt, parent: :projects do
  before do
    @project = Project.get(params[:project_id])
    error 404 if @project.nil?
    has_authority_or_403(@project, :view)
  end

  get :index do |project_id|
    @project = Project.get(params[:project_id])

    add_breadcrumbs(@project.title, url(:projects, :show, :id=>@project.id))
    add_breadcrumbs('gantt', url(:gantt, :index, :project_id=>@project.id))

    render 'projects/gantt/index'
  end
end
