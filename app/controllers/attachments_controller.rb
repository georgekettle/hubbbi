class AttachmentsController < ApplicationController
  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    authorize @attachment.record, :update?

    @attachment.purge
    redirect_to params[:redirect_path]
  end
end
