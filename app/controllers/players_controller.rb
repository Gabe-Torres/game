class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  def show
    @player = Player.find_by(id: params[:id])
    @statistics = Commands::GetStatistics.call(player: @player)
    @active_problem_groups = Problem.where(level: @player.level).group_by(&:x).transform_values do |problems|
      problems.map do |problem|
        statistic = @statistics.find { |statistic| statistic.display_problem == problem.display }
        PlayerProblem.new(player: @player, problem: problem, percent_correct: statistic&.percent_correct, times_seen: statistic&.total_responses.to_i)
      end
    end.values
  end

  def new
    @player = Player.new
  end

  def create
    @player = Commands::CreatePlayer.call(input: player_params)
    redirect_to player_path(@player)
  end

  def edit
    @player = Player.find_by(id: params[:id])
  end

  def update
    @player = Player.update(player_params)
    redirect_to player_path(@player)
  end

  def destroy
    @player = Player.find_by(id: params[:id])
    @player.destroy
    redirect_to new_player_path
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end
end
