# coding: utf-8

Daphne.controllers :issues do

  get :new do
    @issue = Issue.new
    render 'issue/new'
  end

  post :create do
    @issue = Issue.new(params[:issue])

    if @issue.save
      flash[:success] = 'Issue was successfully created.'
      redirect url(:issues, :edit, :id => @issue.id)
    else
      render 'issues/new'
    end
  end

  get :edit, :with => :id do
    p params
    @issue = Issue.get(params[:id])
    render 'issues/edit'
  end

  put :update, :with => :id do
    @issue = Issue.get(params[:id])
    if @issue.update(params[:issue])
      flash[:success] = 'Issue was successfully updated.'
      redirect url(:issues, :edit, :id => @issue.id)
    else
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
