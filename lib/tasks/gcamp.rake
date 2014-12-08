namespace :gcamp do
  desc "Cleanup invalid memberships and comments"
  task cleanup: :environment do
    existing_projects = Project.pluck(:id)
    existing_users = User.pluck(:id)
    existing_tasks = Task.pluck(:id)

    invalid_memberships = Membership.where.not(project_id: existing_projects)
    if invalid_memberships.empty?
      puts "0 memberships deleted due to invalid project_id"
    else
      invalid_memberships.each do |membership|
        puts "Membership #{membership.id} deleted due to invalid project_id"
        membership.destroy
      end
    end

    invalid_memberships = Membership.where.not(user_id: existing_users)
    if invalid_memberships.empty?
      puts "0 memberships deleted due to invalid user_id"
    else
      invalid_memberships.each do |membership|
        puts "Membership #{membership.id} deleted due to invalid user_id"
        membership.destroy
      end
    end

    invalid_comments = Comment.where.not(task_id: existing_tasks)
    if invalid_comments.empty?
      puts "0 comments deleted due to invalid task_id"
    else
      invalid_comments.each do |comment|
        puts "Comment #{comment.id} deleted due to invalid task_id"
        comment.destroy
      end
    end
  end
end
