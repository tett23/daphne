Daphne.controllers :root do

  get :index, :map=>'/' do
    @issues = Issue.list(nil).page(params[:page] || 1).per(ISSUE_PER_PAGE)
    @issue_close_count = Issue.aggrigate(nil, :close, current_account.id)
    @issue_new_count = Issue.aggrigate(nil, , :new, current_account.id)

    render 'root/index'
  end

end
