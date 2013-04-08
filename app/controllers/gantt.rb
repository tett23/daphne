# coding: utf-8

Daphne.controllers :gantt, parent: :projects do
  get :index do |project_id|
    @project = Project.get(params[:project_id])
    return error 404 if @project.nil?
    has_authority_or_403(@project)

    add_breadcrumbs(@project.title, url(:projects, :show, :id=>@project.id))
    add_breadcrumbs('gantt', url(:gantt, :index, :project_id=>@project.id))

    render 'projects/gantt/index'
  end
end