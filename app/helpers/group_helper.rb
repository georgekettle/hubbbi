module GroupHelper
  def selected_group
    return Group.find(session[:selected_group]["id"]) if session[:selected_group] && user_signed_in? && member_of_group
    nil
  end

  def selected_group_member
    return member_of_group if session[:selected_group] && user_signed_in?
    nil
  end

  private

  def member_of_group
    current_user.group_members.find_by(group_id: session[:selected_group]["id"])
  end
end
