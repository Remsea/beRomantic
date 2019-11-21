class MemosController < ApplicationController

  def create
    @newmemo = Memo.new(param_data)
    @newmemo.user = current_user
    if @newmemo.save
      respond_to do |format|
        format.html { redirect_to partenaires_path }
        format.js # <-- will render `app/views/memo/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { redirect_to partenaires_path }
        format.js # <-- idem
      end
    end
  end

  def udpate
  end

  def destroy
    @tdmemo = Memo.find(params[:id])
    @tdmemo.destroy
  end

  private

  def param_data
    params.permit(:content, :calendardate)
  end

end
