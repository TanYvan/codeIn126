module ArbitmanHelper
    #显示仲裁员的头像
    #增加  苏获
    #增加时间 20090508
    #返回一个用来显示用户头像的image标签
    def photo_tag(tb_arbitman)
        image_tag(tb_arbitman.tb_photo.url, :border => 1)
    end
    #返回一个用来显示头像缩略版本的image标签
    def thumbnail_tag(tb_arbitman)
        image_tag(tb_arbitman.tb_photo.thumbnail_url, :border => 1)
    end
end
