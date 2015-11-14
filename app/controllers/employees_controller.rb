class EmployeesController < ApplicationController
  ## TODO not sure if we need this??
  before_action :set_employee, only: [:update, :destroy]
  before_action :authenticate_employee!, only: [:index, :update, :destroy]
  before_action :set_organization, only: [:index, :update, :destroy]

  def index
    if current_employee.admin
      @employees = current_employee.organization.employees.all
      render "index.json.jbuilder", status: :ok
    else
      render json: { errors: "You need to be an admin to do that" }
    end
  end

  def new
    if org.employees.count == 0
      @employee = Employee.new(username: params[:username],
                               password: params[:password],
                               organization_id: params[:organization_id],
                               admin: true)
    else
      @employee = Employee.new(username: params[:username],
                               password: params[:password],
                               organization_id: params[:organization_id],
                               admin: false)
    end

    if @employee.save
      render "new.json.jbuilder", status: :created
    else
      render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    @employee = Employee.find_by(username: params[:username])
    if @employee && @employee.authenticate(params["password"])
      render "create.json.jbuilder", status: :accepted
    else
      render json: { errors: "username or password incorrect"}, status: :unauthorized
    end
  end

  def update
    if current_employee.admin
      deck.update(employee_params)
      render json: { success: "Employee updated successfully" }, status: :ok
    else
      render json: { errors: "You don't have permission to update that employee" }, status: :unathorized
    end
  end

  def destroy
    if current_employee.admin
      @employee.destroy
      render json: { success: "Employee deleted successfully" }, status: :ok
    else
      render json: { errors: "You don't have permission to delete that employee" }, status: :unauthorized
    end
  end
end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    def set_organization
      @org = Organization.find_by(id: params[:organization_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:username)
    end


end
