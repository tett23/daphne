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
    gantt = Issue.list(current_account.id, options)

    gantt.to_json
  end
end
