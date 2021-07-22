class GroupMembers::LinksController < ::LinksController
  def new
    @link = @linkable.links.new
    authorize @linkable, :links?
  end

  private

    def set_linkable
      @linkable = GroupMember.find(params[:group_member_id])
    end
end
