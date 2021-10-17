class AddPositionToCourseMember < ActiveRecord::Migration[6.1]
  def change
    add_column :course_members, :position, :integer
    GroupMember.all.each do |group_member|
      group_member.course_members.order(:updated_at).each.with_index(1) do |course_member, index|
        course_member.update_column :position, index
      end
    end
  end
end
