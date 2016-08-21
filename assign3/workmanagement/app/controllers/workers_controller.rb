class WorkersController < ApplicationController
  
  def index
    @all_workers = Worker.all
    
    if @all_workers.count == 0
      flash.now[:alert] = 'No Workers Found'
    end
  end
  
  def new
    @worker = Worker.new
  end
  
  def create
    @worker = Worker.new(worker_params)
    if @worker.save
      redirect_to workers_path, notice: 'Successfully Created Worker'
    else
      render :new
    end
  end
  
  def show
    @worker = Worker.find(params[:id])
    session[:worker_id] = @worker.id
  end
  
  def assign
    @worker = Worker.find(session[:worker_id])
    @work = Work.find(params[:work_id])
    @work.work_status_id = 2
    @work.worker = @worker
    
    @work.save
    redirect_to worker_path(:id => @worker.id), notice: "Assigned #{@work.name} to #{@worker.first_name} #{@worker.last_name}"
  end
  
  private

  def worker_params
    params.require(:worker).permit(:first_name, :last_name)
  end
end
