# coding: utf-8

Daphne.controllers :projects do
  get :new do
    @project = Project.new
    @color_list = Color.select_list

    render 'projects/new'
  end

  post :create do
    params[:project][:color_id] = nil if params[:project][:color_id].blank?

    @project = Project.new(params[:project])
    @project.account_id = current.id

    if @project.save
      flash[:success] = 'Project was successfully created.'
      redirect url(:projects, :edit, :id => @project.id)
    else
      @color_list = Color.select_list
      render 'projects/new'
    end
  end

  get :edit, :with => :id do
    @project = Project.get(params[:id])
    @color_list = Color.select_list

    render 'projects/edit'
  end

  put :update, :with => :id do
    @project = Project.get(params[:id])

    params[:project][:color_id] = nil if params[:project][:color_id].blank?

    if @project.update(params[:project])
      flash[:success] = 'Project was successfully updated.'
      redirect url(:projects, :edit, :id => @project.id)
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
