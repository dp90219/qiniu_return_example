class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]

  # GET /pictures
  # GET /pictures.json
  def index
    @pictures = Picture.all
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
  end

  # GET /pictures/new
  def new
  end

  # GET /pictures/1/edit
  def edit
  end

  # POST callback

  def callback
    @picture = Picture.new
    puts "----------------------------------------------------------begin"
    puts params.keys
    data = (params.keys.sort {|i| -i.length})[0]
    data = data[1...-1].split(',').map{|item| item.split(':')}.map{|item| item[0] = item[0].strip[1...-1]; item}.to_h
    puts "------------------#{data}"

    @picture.key = data["key"]
    @picture.width =  data["width"]
    @picture.height =  data["height"]
    puts "data---------------------#{data.class}"
    puts @picture.inspect
    puts "----------------------------------------------------------end"
    if @picture.save
      render json: @picture
    else
      render json: {success: false}
    end

  end

  # GET /returnback
  def returnback
    data = Qiniu::Utils.safe_json_parse Qiniu::Utils.urlsafe_base64_decode params[:upload_ret]


    # render json: data

    @picture = Picture.new
    @picture.key = data["key"]
    @picture.width = data["width"]
    @picture.height = data["height"]
    @picture.url = Qiniu.download("lptest", data["key"])

    if @picture.save
      redirect_to @picture
    else 
      render json: data
    end
  end

  # POST /pictures
  # POST /pictures.json
  def create
    @picture = Picture.new(picture_params)

    respond_to do |format|
      if @picture.save
        format.html { redirect_to @picture, notice: 'Picture was successfully created.' }
        format.json { render :show, status: :created, location: @picture }
      else
        format.html { render :new }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pictures/1
  # PATCH/PUT /pictures/1.json
  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to @picture, notice: 'Picture was successfully updated.' }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render :edit }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    Qiniu.delete("lptest", @picture.key)
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to pictures_url, notice: 'Picture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picture
      @picture = Picture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      params.require(:picture).permit(:name, :height, :width, :url)
    end
end
