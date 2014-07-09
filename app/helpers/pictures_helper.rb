module PicturesHelper
  def uptoken
    # Qiniu.generate_upload_token(scope: "lptest", return_url: "http://112.124.46.39/returnback" ,return_body: %({"key": $(key), "hash": $(etag), "width": $(imageInfo.width), "height": $(imageInfo.height)}))

    Qiniu.generate_upload_token(scope: "lptest", callback_url: "http://112.124.46.39:3000/callback", callback_body: %({"key": $(key), "hash": $(etag), "height": $(imageInfo.height), "width": $(imageInfo.width), "persistent_id": $(persistentId)}), persistent_ops: "imageView2/5/w/400/h/400/format/png|imageMogr2/rotate/45", persistent_notify_url: "http://112.124.46.39:3000/notify")
  end

  def key
    Time.now.to_i
  end
end
