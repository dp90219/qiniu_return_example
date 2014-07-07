module PicturesHelper
  def uptoken
    # Qiniu.generate_upload_token(scope: "lptest", return_url: "http://112.124.46.39/returnback" ,return_body: %({"key": $(key), "hash": $(etag), "width": $(imageInfo.width), "height": $(imageInfo.height)}))
    Qiniu.generate_upload_token(scope: "lptest", callback_url: "http://112.124.46.39:3000/callback" ,callback_body: %({"key": $(key), "hash": $(etag), "width": $(imageInfo.width), "height": $(imageInfo.height)}))
  end

  def key
    Time.now.to_i
  end
end
