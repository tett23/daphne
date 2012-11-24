# coding: utf-8

Daphne.controllers :issues do

  get :new do
    @issue = Issue.new
    @select_list = Project.select_list(current.id)
    render 'issue/new'
  end

  get :show, :with=>:id do |id|
    @issue = Issue.detail(id)
    return error 404 if @issue.nil?

    render 'issues/show'
  end

  post :create do
    params[:issue][:project_id] = nil if params[:issue][:project_id].blank?

    @issue = Issue.new(params[:issue])
    @issue.account_id = current.id

    if @issue.save
      flash[:success] = 'Issue was successfully created.'
      redirect url(:issues, :edit, :id => @issue.id)
    else
      @select_list = Project.select_list(current.id)
      render 'issues/new'
    end
  end

  get :edit, :with => :id do
    @issue = Issue.get(params[:id])
    @select_list = Project.select_list(current.id)
    render 'issues/edit'
  end

  put :update, :with => :id do
    @issue = Issue.get(params[:id])

    params[:issue][:project_id] = nil if params[:issue][:project_id].blank?

    if @issue.update(params[:issue])
      flash[:success] = 'Issue was successfully updated.'
      redirect url(:issues, :edit, :id => @issue.id)
    else
      @select_list = Project.select_list(current.id)
      render 'issues/edit'
    end
  end

  delete :destroy, :with => :id do
    static_page = Issue.get(params[:id])
    if static_page.destroy
      flash[:success] = 'Issue was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy Issue!'
    end
    redirect url(:issues, :index)
  end

end
