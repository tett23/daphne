Daphne.controllers :root do

  get :index, :map=>'/' do
    @issues = Issue.list(current_account.id)

    render 'root/index'
  end

end
