class IssuesController < ApplicationController
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end

  def index
    Issues::FeedableQuery.for_user(current_user, params) do |m|
      m.success { |issues| api_response(issues) }
      m.failure { api_response([]) }
    end
  end

  def create
    exec_command(Issues::CreateCommand, user: current_user, params: issue_params)
  end

  def update
    exec_command(
      Issues::UpdateCommand,
      id: params[:id],
      user: current_user,
      params: issue_params
    )
  end

  def destroy
    Issues::DestroyCommand.run(id: params[:id], user: current_user) do |m|
      m.success { head :ok }
      m.failure { |errors| error_response(errors) }
    end
  end

  def assign
    exec_command(Issues::AssignCommand, id: params[:id], assignee: current_user)
  end

  def unassign
    exec_command(Issues::UnassignCommand, id: params[:id], assignee: current_user)
  end

  def in_progress
    exec_command(Issues::InProgressCommand, id: params[:id], assignee: current_user)
  end

  def resolved
    exec_command(Issues::ResolvedCommand, id: params[:id], assignee: current_user)
  end

  private

  def issue_params
    params.require(:issue).permit([:name, :description])
  end

  def exec_command(command, params)
    command.run(params) do |m|
      m.success { |issue| api_response(issue) }
      m.failure { |errors| error_response(errors) }
    end
  end

  def api_response(items)
    render json: items
  end

  def error_response(errors)
    render json: {errors: errors}, status: :unprocessable_entity
  end
end
