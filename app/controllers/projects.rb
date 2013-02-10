# coding: utf-8

Daphne.controllers :projects do
  get :new do
    @project = Project.new
    @color_list = Color.select_list

    render 'projects/new'
  end

  get :show, :with => :id do
    @project = Project.get(params[:id])
    error 404 if @project.nil?

    @issues = Issue.project(params[:id])

    render 'projects/show'
  end

  post :create do
    params[:project][:color_id] = nil if params[:project][:color_id].blank?

    @project = Project.new(params[:project])
    @project.account_id = current_account.id

    if @project.save
      flash[:success] = "プロジェクト「#{@project.title}」を作成しました"
      redirect url(:projects, :show, :id => @project.id)
    else
      @color_list = Color.select_list
      render 'projects/new'
    end
  end

  get :edit, :with => :id do
    @project = Project.get(params[:id])
    @color_list = Color.select_list

    add_breadcrumbs(@project.title, url(:projects, :show, :id=>@project.id))
    add_breadcrumbs('編集', url(:projects, :edit, :id=>@project.id))

    render 'projects/edit'
  end

  put :update, :with => :id do
    @project = Project.get(params[:id])

    params[:project][:color_id] = nil if params[:project][:color_id].blank?

    if @project.update(params[:project])
      flash[:success] = "プロジェクト「#{@project.title}」を編集しました"
      redirect url(:projects, :show, :id => @project.id)
    else
      @color_list = Color.select_list
      render 'projects/edit'
    end
  end

  delete :destroy, :with => :id do
    static_page = Project.get(params[:id])
    if static_page.destroy
      flash[:success] = 'Project was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy Project!'
    end
    redirect url(:projects, :index)
  end
end
