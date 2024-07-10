class TranscriptsController < ApplicationController
    before_action :set_transcript, only: [:edit, :update]

    def edit
        
    end

    def update
        if @transcript.update(transcript_params)
          redirect_to videos_url, notice: 'Video was successfully updated.'
        else
          render :edit
        end
    end

    private

    def set_transcript
        @transcript = Transcript.find(params[:id])
    end

    def transcript_params
      params.require(:transcript).permit(:content, :video_id)
    end
end
