class AttachmentsController < ApplicationController
  def destroy
    @blob = ActiveStorage::Blob.find_signed(params[:id])
    @blob.attachments.each(&:purge)
    authorize @blob
    redirect_to params[:redirect_path]
  end
end
