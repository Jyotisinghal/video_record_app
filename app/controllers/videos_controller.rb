class VideosController < ApplicationController
    def index
        @videos = Video.all
    end

    def create
      video_file = params[:video]
      transcript_file = params[:transcript]
  
      # Save video and transcript to local storage
      video_path = Rails.root.join('public', 'uploads', video_file.original_filename)
      transcript_path = Rails.root.join('public', 'uploads', transcript_file.original_filename)
  
      File.open(video_path, 'wb') do |file|
        file.write(video_file.read)
      end
  
      File.open(transcript_path, 'wb') do |file|
        file.write(transcript_file.read)
      end
  
      @video = Video.new(title: video_file.original_filename, description: "", user: current_user)
      @transcript = Transcript.new(content: File.read(transcript_path), video: @video)
  
      if @video.save && @transcript.save
        render json: { message: 'Video and transcript saved successfully.' }, status: :created
      else
        render json: { errors: @video.errors.full_messages + @transcript.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def upload_to_cloud
        video = Video.find(params[:id])
        
        s3 = Aws::S3::Resource.new(region: 'us-west-2')
        obj = s3.bucket('my-bucket').object(video.title)
        obj.upload_file(Rails.root.join('public', 'uploads', video.title))
        
        render json: { message: 'Uploaded to cloud successfully.' }
    end

    def destroy
      @video = Video.find(params[:id])
      @video.destroy
      flash[:success] = "The to-do item was successfully destroyed."
      redirect_to videos_url
    end

    private
      def video_params
        params.require(:video).permit(:title, :description, :file)
      end
      
  end
  