module VideosHelper
  def uptoken
    Qiniu.generate_upload_token(scope: "lptest", callback_url: "http://112.124.46.39:3000/videos/callback", callback_body: %({"key": $(key), "hash": $(etag), "persistent_id": $(persistentId)}), persistent_ops: "avthumb/m3u8/segtime/10/video_16x9_440k;vframe/png/offset/10/rotate/90", persistent_notify_url: "http://112.124.46.39:3000/videos/notify")
  end

  def key
    Time.now.to_i
  end
end
