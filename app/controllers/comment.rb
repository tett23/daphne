# coding: utf-8

Daphne.controllers :comments do
  post :create do
    wiki = Wiki.get(params[:comment][:wiki_id])
    error 404 if wiki.nil?
    has_authority_or_403(wiki.project, :issue)

    params[:comment][:account_id] = current_account.id
    @comment = Comment.new(params[:comment])

    action_selector = if wiki.issue_id.nil?
      [:issues, :show, id: wiki.issue_id]
    else
      [:wiki, :show, project_id: wiki.project_id, title: wiki.title]
    end

    if @comment.save
      flash[:success] = "「#{wiki.title}」にコメントを追加しました"
      redirect url(*action_selector)
    else
      flash[:error] = "「#{wiki.title}」へのコメントに失敗しました"
      redirect url(*action_selector)
    end
  end
end
