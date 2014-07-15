class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.all
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
  end

  # POST notify
  def notify
    puts "notify params: --------------------------#{params}"
    items = params[:items]
    if items[0]["cmd"] == "avthumb/m3u8/segtime/10/video_16x9_440k"
      old_key = items[0]["key"]
      new_key = "#{old_key}.m3u8"
      Qiniu::Storage.move("lptest", old_key, "lptest", new_key)

    end
    render json: params
  end

  # POST callback

  def callback
    @video = Video.new
    puts "----------------------------------------------------------begin"
    puts "params.keys: #{params.keys}"
    data = (params.keys.sort {|i| -i.length})[0]
    data = data[1...-1].split(',').map{|item| item.split(':')}.map{|item| item[0] = item[0].strip[1...-1]; item[1].strip!; item}.to_h
    puts "data: #{data}"

    @video.key = data["key"]
    @video.url = Qiniu.download("lptest", data["key"])

    puts "data.class: #{data.class}"
    puts @video.inspect
    puts "----------------------------------------------------------end"
    if @video.save
      render json: {file_path: @video.url}
    else
      render json: {success: false}
    end

  end
  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params)

    respond_to do |format|
      if @video.save
        format.html { redirect_to @video, notice: 'Video was successfully created.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url, notice: 'Video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:name, :key, :url)
    end
end
