Daphne.controllers :root do

  get :index, :map=>'/' do
    @issues = Issue.list(current_account.id).page(params[:page] || 1).per(ISSUE_PER_PAGE)

    render 'root/index'
  end

end
