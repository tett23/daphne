Daphne.controllers :root do

  get :index, :map=>'/' do
    @issues = Issue.list(current.id)

    render 'root/index'
  end

end
