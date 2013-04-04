# coding: utf-8

Daphne.controllers :api_gantt, map: '/api' do
  get :index, provides: [:json], map: '/api/gantt' do
    if params.key?('project_id')
      return error 403 unless Project.detail(params[:project_id]).account_id == current_account.id
    end

    options = {
      :scheduled_on.not => nil
    }
    options[:project_id] = params[:project_id] if params[:project_id]
    gantt = Issue.list(current_account.id, options)

    gantt.to_json
  end
end
