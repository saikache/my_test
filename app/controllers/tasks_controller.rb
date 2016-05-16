class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]


autocomplete :user, :email


  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.where(project_id: params['project_id'])

  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @project = Project.find_by_id(params['project_id'])
    @task = @project.tasks.build
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Project.find(params['task']['project_id']).tasks.build(task_params)
    @project = Project.find(params['project_id'])

    @user = User.find_or_initialize_by(email: params['task']['asigned_to'])
    if (@user.new_record?)
      @user.password = 'password'
      @user.save
      puts "new user saved ******"
    end
    @task.user = @user
    @task.save

    respond_to do |format|
      if @task.save
        format.html { redirect_to  project_task_path(@task.project_id, @task), notice: "Task was successfully created.#{@user.new_record?}" }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update

    # byebug
    respond_to do |format|
      if @task.update(task_params)
        # @task.user = User.find_by_email(params['task']['asigned_to'])
        # @task.user = User.find_or_initialize_by(email: params['task']['asigned_to'])

        @user = User.find_or_initialize_by(email: params['task']['asigned_to'])
        if (@user.new_record?)
          @user.password = 'password'
          @user.save
          puts "new user saved ******"
        end
        @task.user = @user
        @task.save

        format.html { redirect_to project_task_path(@task.project_id, @task), notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to project_tasks_path, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
      @project = @task.project
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :asigned_to, :project_id, :start_date, :end_date, :status)
    end
end
