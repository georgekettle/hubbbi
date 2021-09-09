class GroupMembers::LinksController < ::LinksController
  include Groupable # for set_selected_group method

  def new
    @link = @linkable.links.new
    authorize @linkable, :links?
    set_selected_group(@link.linkable.group)
  end

  private

    def set_linkable
      @linkable = GroupMember.find(params[:group_member_id])
    end
end
