class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[show edit update destroy]
  before_action :set_course, only: %i[new create]

  def index
    @ransack_path = enrollments_path

    @q = Enrollment.ransack(params[:q])
    @pagy, @enrollments = pagy(@q.result.includes(:user))
    authorize @enrollments
  end

  def my_students
    @ransack_path = my_students_enrollments_path

    @q = Enrollment.joins(:course).where(courses: {user: current_user}).ransack(params[:q])
    @pagy, @enrollments = pagy(@q.result.includes(:user))
    render 'index'
  end

  def show; end

  def new
    @enrollment = Enrollment.new
  end

  def edit
    authorize @enrollment
  end

  def create
    # if @course.price > 0
    #   flash[:alert] = "You can not access paid courses yet."
    #   redirect_to new_course_enrollment_path(@course)
    # else
    @enrollment = current_user.buy_course(@course)

    redirect_to course_path(@course), notice: 'You are enrolled!'
    # end
    # @enrollment = Enrollment.new(enrollment_params)
    # @enrollment.price = @enrollment.course.price

    # respond_to do |format|
    #   if @enrollment.save
    #     format.html { redirect_to enrollment_url(@enrollment), notice: "Enrollment was successfully created." }
    #     format.json { render :show, status: :created, location: @enrollment }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @enrollment.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def update
    authorize @enrollment

    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to enrollment_url(@enrollment), notice: 'Enrollment was successfully updated.' }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @enrollment
    @enrollment.destroy

    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: 'Enrollment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_course
    @course = Course.friendly.find(params[:course_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_enrollment
    @enrollment = Enrollment.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def enrollment_params
    # params.require(:enrollment).permit(:course_id, :user_id, :rating, :review, :price)
    params.require(:enrollment).permit(:rating, :review)
  end
end
