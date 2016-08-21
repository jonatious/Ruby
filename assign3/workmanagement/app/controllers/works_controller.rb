class WorksController < ApplicationController
  def index
    @all_works = Work.all
    if @all_works.count == 0
      flash.now[:alert] = 'No Works Found'
    end
  end
  
  def new
    @work = Work.new
  end
  
  def create
    @work = Work.new(work_params)
    if @work.valid?
      @work.save
      redirect_to works_path, notice: 'Successfully Created Work'
    else
      render :new
    end
  end
  
  def show
    @work = Work.find(params[:id])
    session[:work_id] = @work.id
  end
  
  def assign
    @worker = Worker.find(params[:worker_id])
    @work = Work.find(session[:work_id])
    @work.work_status_id = 2
    @work.worker = @worker
    
    @work.save
    redirect_to work_path(:id => @work.id), notice: "Assigned #{@work.name} to #{@worker.first_name} #{@worker.last_name}"
  end
  
  def set_completed
    @work = Work.find(session[:work_id])
    @work.work_status_id = 3
    
    @work.save
    redirect_to work_path(:id => @work.id)
  end
  
  private

  def work_params
    params.require(:work).permit(:name)
  end
end
