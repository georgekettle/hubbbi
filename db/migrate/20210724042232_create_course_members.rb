class CreateCourseMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :course_members do |t|
      t.references :course, null: false, foreign_key: true
      t.references :group_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
