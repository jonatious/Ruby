class WorksController < ApplicationController
  
  def index
    @work = Work.new
    @all_works = Work.all
    if @all_works.count == 0
      flash.now[:alert] = 'No Works Found'
    end
  end
  
  def create
    @work = Work.new(work_params)
    render :error unless @work.save
  end
  
  def show
    @work = Work.find(params[:id])
    session[:work_id] = @work.id
  end
  
  def assign
    @worker = Worker.find(params[:worker_id])
    @work = Work.find(session[:work_id])
    @work.work_status = WorkStatus.find_by_status("Assigned")
    @work.worker = @worker
    
    @work.save
    redirect_to work_path(:id => @work.id), notice: "Assigned #{@work.name} to #{@worker.first_name} #{@worker.last_name}"
  end
  
  def set_completed
    @work = Work.find(session[:work_id])
    @work.work_status = WorkStatus.find_by_status("Completed")
    
    @work.save
    redirect_to work_path(:id => @work.id)
  end
  
  private

  def work_params
    params.require(:work).permit(:name)
  end
end
