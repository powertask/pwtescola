class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  respond_to :html
  layout 'window'
  
  def index
    @students = Student.all
  end

  def show
  end

  def new
    @student = Student.new
    @student.unit_id = current_user.unit_id
    @student.debtor_id = params[:format]
    @student.customer_id = session[:customer_id]
    @debtor = Debtor.find params[:format]
  end


  def edit
    @debtor = Debtor.find @student.debtor_id
  end


  def create
    @student = Student.new(student_params)
    @debtor = Debtor.find(@student.debtor_id)
    @student.save

    if @student.errors.present?
      respond_with @student
    else
      respond_with @debtor
    end

  end


  def update
    @student.update_attributes(student_params)
    @debtor = Debtor.find(@student.debtor_id)

    if @student.errors.present?
      respond_with @student
    else
      redirect_to( debtor_path( @student.debtor.id ) )
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:unit_id, :customer_id, :debtor_id, :name, :course_id)
    end
end
