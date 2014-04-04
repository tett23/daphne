# coding: utf-8

Daphne.controllers :wiki, :parent=>:projects do
  before do
    @project = Project.detail(params[:project_id])
    has_authority_or_403(@project, :view)
  end

  get :index do
    @wiki = Wiki.project_index(@project.account_id, params[:project_id])

    add_breadcrumbs(@wiki.project.title, url(:projects, :show, :id=>@wiki.project.id))
    add_breadcrumbs('wiki', url(:wiki, :index, :project_id=>@wiki.project.id))

    render 'wiki/show'
  end

  get :list do
    @project = Project.detail(params[:project_id])
    @wikis = Wiki.list(params[:project_id])

    add_breadcrumbs(@project.title, url(:projects, :show, :id=>@project.id))
    add_breadcrumbs('wiki', url(:wiki, :index, :project_id=>@project.id))
    add_breadcrumbs('list', url(:wiki, :list, :project_id=>@project.id))

    render 'wiki/list'
  end

  get :show, :map=>'/projects/:project_id/wiki/:title', :priority => :low do
    @wiki = Wiki.detail(@project.account_id, params[:project_id], params[:title])

    add_breadcrumbs(@wiki.project.title, url(:projects, :show, :id=>@wiki.project.id))
    add_breadcrumbs('wiki', url(:wiki, :index, :project_id=>@wiki.project.id))
    add_breadcrumbs(@wiki.title, url(:wiki, :show, :project_id=>@wiki.project.id, :title=>@wiki.title))

    render 'wiki/show'
  end

  get :edit, :map=>'/projects/:project_id/wiki/:title/edit' do
    @wiki = Wiki.detail(@project.account_id, params[:project_id], params[:title])
    has_authority_or_403(@project, :issue)

    add_breadcrumbs(@wiki.project.title, url(:projects, :show, :id=>@wiki.project.id))
    add_breadcrumbs('wiki', url(:wiki, :index, :project_id=>@wiki.project.id))
    add_breadcrumbs(@wiki.title, url(:wiki, :show, :project_id=>@wiki.project.id, :title=>@wiki.title))

    render 'wiki/edit'
  end

  post :update, :with=>:title do
    @wiki = Wiki.detail(@project.account_id, params[:project_id], params[:title])
    has_authority_or_403(@project, :issue)

    if @wiki.update(params[:wiki])
      flash[:success] = @wiki.title+'を編集しました'

      if @wiki.is_project_index
        redirect url(:wiki, :index, :project_id=>params[:project_id])
      else
        redirect url(:wiki, :show, :project_id=>params[:project_id], :title=>@wiki.title)
      end
    else
      render 'wiki/show'
    end
  end
end
