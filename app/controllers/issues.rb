# coding: utf-8

Daphne.controllers :issues do
  get :new do
    @issue = Issue.new

    @select_list = Project.select_list(current_account.id)
    render 'issue/new'
  end

  get :show, :with=>:id do |id|
    @issue = Issue.detail(id)
    has_authority_or_403(@issue.project, :issue)
    @comments = Comment.list(@issue.wiki.id)

    @issue.wiki.update(issue: @issue)

    unless @issue.project.blank?
      add_breadcrumbs(@issue.project.title, url(:projects, :show, :id=>@issue.project.id))
    else
      add_breadcrumbs('プロジェクト未所属', url(:projects, :not_belong))
    end
    add_breadcrumbs(@issue.title, url(:issues, :show, :id=>@issue.id))

    render 'issues/show'
  end

  post :create do
    issue = Issue.parse_text(current_account.id, params[:issue][:body])
    has_authority_or_403(Project.get(issue[:project_id]), :issue)
    issue[:scheduled_on] = params[:issue][:scheduled_on]
    @issue = Issue.new(issue)
    wiki = Wiki.create_by_issue(@issue)
    @issue[:wiki_id] = wiki.id

    if @issue.save
      wiki.update(issue: @issue)
      flash[:success] = "タスク「#{@issue.title}」を作成しました"
      redirect url(:issues, :show, :id => @issue.id)
    else
      flash[:error] = "タスク「#{@issue.title}」の作成に失敗しました"
      render 'issues/new'
    end
  end

  get :edit, :with => :id do
    @issue = Issue.get(params[:id])
    return error 404 if @issue.nil?
    has_authority_or_403(@issue.project, :issue)

    add_breadcrumbs(@issue.project.title, url(:projects, :show, :id=>@issue.project.id)) unless @issue.project.blank?
    add_breadcrumbs(@issue.title, url(:issues, :show, :id=>@issue.id))
    add_breadcrumbs('編集', url(:issues, :edit, :id=>@issue.id))

    render 'issues/edit'
  end

  put :update, :with => :id do
    @issue = Issue.get(params[:id])
    has_authority_or_403(@issue.project, :issue)

    issue = params[:issue]
    is_update_wiki = params[:issue].key?('body')
    if is_update_wiki
      parsed = Issue.parse_text(current_account.id, params[:issue][:body])
      params[:issue].delete('body')
      issue = parsed.merge(issue)
    end


    if @issue.update(issue)
      @issue.wiki.update_by_issue(@issue) if is_update_wiki

      flash[:success] = "タスク「#{@issue.title}」を編集しました"
      redirect url(:issues, :show, :id => @issue.id)
    else
      @select_list = Project.select_list(current_account.id)
      render 'issues/edit'
    end
  end

  delete :destroy, :with => :id do
    static_page = Issue.get(params[:id])
    has_authority_or_403(static_page.project, :issue)

    static_page = Issue.get(params[:id])
    if static_page.destroy
      flash[:success] = 'Issue was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy Issue!'
    end
    redirect url(:issues, :index)
  end

  put :status_close, :with=>:id do
    @issue = Issue.detail(params[:id])
    return error 404 if @issue.nil?
    has_authority_or_403(@issue.project, :issue)

    if @issue.status_close
      flash[:success] = "タスク「#{@issue.title}」を完了しました"
    else
      flash[:error] = "タスク「#{@issue.title}」を完了できませんでした"
    end
    redirect url(:issues, :show, :id => @issue.id)
  end

  put :status_new, :with=>:id do
    @issue = Issue.detail(params[:id])
    return error 404 if @issue.nil?
    has_authority_or_403(@issue.project, :issue)

    if @issue.status_new
      flash[:success] = "タスク「#{@issue.title}」を未完了にしました"
    else
      flash[:error] = "タスク「#{@issue.title}」を未完了にできませんでした"
    end
    redirect url(:issues, :show, :id => @issue.id)
  end

  put :tags, :with=>:id do
    @issue = Issue.detail(params[:id])
    return error 404 if @issue.nil?
    has_authority_or_403(@issue.project, :issue)

    IssueTag.all(issue_id: params[:id]).destroy
    Tag.create_by_text(params[:issue][:tags], current_account.id).each do |tag|
      @issue.tags << tag
    end

    if @issue.save
      flash[:success] = "タスク「#{@issue.title}」のタグを「#{@issue.tags_text}」に設定しました"
    else
      flash[:success] = "タスク「#{@issue.title}」のタグを「#{@issue.tags_text}」に設定できませんでした"
    end
    redirect url(:issues, :show, :id => @issue.id)
  end
end
