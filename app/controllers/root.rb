Daphne.controllers :root do

  get :index, :map=>'/' do
    @issues = Issue.list(current_account.id).page(params[:page] || 1).per(ISSUE_PER_PAGE)
    @issue_close_count = Issue.aggrigate(current_account.id, :close)
    @issue_new_count = Issue.aggrigate(current_account.id, :new)

    render 'root/index'
  end

end
