class WorkersController < ApplicationController
  
  def index
    @worker = Worker.new
    @all_workers = Worker.all
    
    if @all_workers.count == 0
      flash.now[:alert] = 'No Workers Found'
    end
  end
  
  def create
    @worker = Worker.new(worker_params)
    render :error unless @worker.save
  end
  
  def show
    @worker = Worker.find(params[:id])
    session[:worker_id] = @worker.id
  end
  
  def assign
    @worker = Worker.find(session[:worker_id])
    @work = Work.find(params[:work_id])
    @work.work_status = WorkStatus.find_by_status("Assigned")
    @work.worker = @worker
    
    @work.save
    redirect_to worker_path(:id => @worker.id), notice: "Assigned #{@work.name} to #{@worker.first_name} #{@worker.last_name}"
  end
  
  private
  def worker_params
    params.require(:worker).permit(:first_name, :last_name)
  end
end