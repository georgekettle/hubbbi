class ProgressionsController < ApplicationController

  def create
    @progression = Progression.new(progression_params)
    @progression.group_member = Current.group_member
    authorize @progression
    respond_to do |format|
      if @progression.save
        format.turbo_stream {}
      else
        format.turbo_stream {}
      end
    end
  end

  def update
    @progression = Progression.find(params[:id])
    authorize @progression
    respond_to do |format|
      if @progression.update(progression_params)
        format.turbo_stream {}
      else
        format.turbo_stream {}
      end
    end
  end

  private

  def progression_params
    params.require(:progression).permit(:progressable_type, :progressable_id, :current, :total)
  end
end
