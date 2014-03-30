# coding: utf-8

Daphne.controllers :api_gantt, map: '/api' do
  get :index, provides: [:json], map: '/api/gantt' do
    if params.key?('project_id')
      has_authority_or_403(Project.detail(params[:project_id]), :view)
    end

    options = {
      :scheduled_on.not => nil
    }
    options[:project_id] = params[:project_id] if params[:project_id]
    account_id = (params[:project_id].nil? ? current_account.id : Project.detail(params[:project_id]).account_id)
    gantt = Issue.list(account_id, options)

    gantt.to_json
  end
end
