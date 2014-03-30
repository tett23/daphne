# coding: utf-8

Daphne.controllers :authority, :parent=>:projects do
  before do
    @project = Project.detail(params[:project_id])
    has_authority_or_403(@project, :all)
  end

  get :index do
    @authorities = Authority.project_index(params[:project_id])

    add_breadcrumbs(@project.title, url(:projects, :show, :id=>@project.id))
    add_breadcrumbs('config', url(:authority, :index, :project_id=>@project.id))

    render 'projects/config/index'
  end

  get :new do
    render 'projects/config/authority/new'
  end

  post :create do
    @authority = Authority.new(params[:authority])

    if @authority.save
      flash[:success] = '新規権限を作成しました'
      redirect url(:authority, :index, project_id: @project.id)
    else
      flash[:error] = '新規権限の作成に失敗しました'
      render 'projects/config/authority/new'
    end
  end

  get :list do
    @wikis = Wiki.list(current_account.id, params[:project_id])

    add_breadcrumbs(@project.title, url(:projects, :show, :id=>@project.id))
    add_breadcrumbs('wiki', url(:wiki, :index, :project_id=>@project.id))
    add_breadcrumbs('list', url(:wiki, :list, :project_id=>@project.id))

    render 'wiki/list'
  end

  get :show, :map=>'/projects/:project_id/wiki/:title' do
    @wiki = Wiki.detail(current_account.id, params[:project_id], params[:title])

    add_breadcrumbs(@wiki.project.title, url(:projects, :show, :id=>@wiki.project.id))
    add_breadcrumbs('wiki', url(:wiki, :index, :project_id=>@wiki.project.id))
    add_breadcrumbs(@wiki.title, url(:wiki, :show, :project_id=>@wiki.project.id, :title=>@wiki.title))

    render 'wiki/show'
  end

  get :edit, with: [:authority_id] do
    @authority = Authority.get(params[:authority_id])

    render 'projects/config/authority/edit'
  end

  put :update, with: [:authority_id] do
    @authority = Authority.get(params[:authority_id])

    if @authority.update(params[:authority])
      flash[:success] = '権限を編集作成しました'
      redirect url(:authority, :index, project_id: @project.id)
    else
      flash[:error] = '権限の編集に失敗しました'
      render 'projects/config/authority/edit'
    end
  end

  delete :destroy, with: [:authority_id] do
    @authority = Authority.get(params[:authority_id])
    if @authority.nil?
      flash[:error] = '存在しない権限について操作されようとしました'
    else
      @authority.destroy
      flash[:success] = "権限ID#{params[:authority_id]}を削除しました"
    end

    redirect url(:authority, :index, project_id: params[:project_id])
  end
end
