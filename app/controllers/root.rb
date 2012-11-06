Daphne.controllers :root do

  get :index, :map=>'/' do
    @issues = Issue.all
    render 'root/index'
  end

end
