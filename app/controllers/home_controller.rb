class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @courses = Course.all.limit(3)
    @latest_couses = Course.latest_courses
    @latest_good_reviews = Enrollment.reviewed.latest_reviews
    @top_rated_courses = Course.top_rated
    @popular_courses = Course.popular_courses
    @purchased_courses = Course.joins(:enrollments).where(enrollments: {user: current_user}).order(created_at: :desc).limit(3)
  end

  def activity
    @activities = PublicActivity::Activity.all
  end
end
