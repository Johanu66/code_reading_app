class AgendasController < ApplicationController
  before_action :set_agenda, only: %i[ destroy ]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda') 
    else
      render :new
    end
  end

  def destroy
    if current_user.id == @agenda.user_id || current_user.id == @agenda.team.owner_id
      @agenda.articles.destroy_all
      @agenda.destroy

      TeamMailer.agenda_deleted_mail(@agenda.user.email).deliver
      @agenda.team.assigns.each do |assign|
        TeamMailer.agenda_deleted_mail(assign.user.email).deliver
      end

      redirect_to dashboard_url, notice: "The agenda has been deleted with its articles"
    else
      redirect_to dashboard_url, notice: "Only the team leader or this agenda creator can delete it"
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
