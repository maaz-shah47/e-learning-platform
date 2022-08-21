module CoursesHelper
  def enrollment_button(course)
    if current_user
      if course.user == current_user
        link_to 'You created this course. View analytics', course_path(course)
      elsif course.enrollments.where(user_id: current_user.id).any?
        link_to course_path(course) do
          #"You bought this course. Keep learning" +
          "<i class='fa fa-spinner'></i>".html_safe + " " +
          number_to_percentage(course.progress(current_user), precision: 0)
        end
      elsif course.price > 0
        link_to number_to_currency(course.price), new_course_enrollment_path(course), class: 'btn btn-success'
      else
        link_to 'Free', new_course_enrollment_path(course), class: 'btn btn-success'
      end
    else
      link_to 'Check Price', new_course_enrollment_path(course), class: 'btn btn-warning btn-sm'
    end
  end

  def review_button(course)
    user_course = course.enrollments.where(user: current_user)
    if current_user && user_course.any?
      if user_course.pending_review.any?
        link_to 'Write a review', edit_enrollment_path(user_course.first), class: 'btn btn-success'
      else
        'You already reviewed this course'
        link_to 'View review', enrollment_path(user_course.first)
      end
    end
  end
end
