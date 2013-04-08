# coding: utf-8

Daphne.controllers :stat, map: '/api' do
  get :index, provides: [:json] do
    if params.key?('project_id') && params[:project_id]!='all'
      has_authority_or_403(Project.detail(params[:project_id]))
    end

    stat = IssueStat.stat((Date.today-1.month)..Date.today, current_account.id, params[:project_id])

    stat.to_json
  end
end
