class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    # @tasks = current_user.tasks.order(created_at: :desc)
    #@tasks = Task.where(user_id: current_user_id)と同様
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true)
  end

  def show
    # @task = current_user.tasks.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end

  def create
    @task = current_user.tasks.new(task_params)

    if params[:back].present?
      render :new
      return
    end

    if @task.save
      TaskMailer.creation_email(@task).deliver_now
      logger.debug "task: #{@task.attributes.inspect}"
      redirect_to @task, notice:"タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
    # @task = current_user.tasks.find(params[:id])
  end

  def update
    # task = current_user.tasks.find(params[:id])
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
  end

  def destroy
    # task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}を削除しました」"
  end

  private
  def task_params
    params.require(:task).permit(:name, :description)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end


end
