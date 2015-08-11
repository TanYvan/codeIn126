#照片类，用于存储仲裁员头像
#创建人 苏获
#创建时间 20090508
class TbPhoto < ActiveRecord::Base
#    URL_STUB = "upload/images"
#    DIRECTORY = File.join("upload","images")
#    ## 图像大小
#    IMG_SIZE = '"240*300>"'
#    THUMB_SIZE = '"50*64"'
#    def initialize(tb_arbitman,image =nil)
#        @tb_arbitman =tb_arbitman
#        @image = image
#        Dir.mkdir(DIRECTORY) unless File.directory?(DIRECTORY)
#    end
#    def exists?
#        File.exists?(File.join(DIRECTORY,filename))
#    end
#    alias exist? exists?
#    #
#    def url
#        "#{URL_STUB}#{filename}"
#    end
#    #
#    def thumbnail_url
#        "#{URL_STUB}#{thumbnail_name}"
#    end
#    # 私有函数
#    # 返回头像的文件名
#    def filename
#        "#{@tb_arbitman.Name}.png"  # 重点
#    end
#    # 返回缩略版本的文件名
#    def thumbnail_name
#        "#{@tb_arbitman.Name}_thumbnail.png"
#    end
#    # 保存图像文件
#    def save
#        valid_file? and successfl_conversion?
#    end
#    # 尝试调整图像文件的大小并转换为PNG格式
#    def successful_conversion?
#        # 为转换准备文件名
#        source = File.join("tmp","#{@tb_arbitman.Name}_full_size")
#        full_size = File.join(DIRECTORY,filename)
#        thumbnail = File.join(DIRECTORY,thumbnail_name)
#        # 确保较小的和较大的图像都能够写入一个常规文件
#        # 较小的显示为StringIO,较大的显示为Tempfiles
#        File.open(source,"wb") { |f| f.write(@image.read)}
#        # 转换
#        img = system("#{convert} #{source} -resize #{IMG_SIZE} #{full_size}")
#        thumb = system("#{convert} #{source} -resize #{THUMB_SIZE} #{thumbnail}")
#        File.delete(source) if File.exists?(source)
#        #转换必须成功，否则将返回一个错误
#        unless img and thumb
#            errors.add_to_base("上传失败.重试一次？")
#            return false
#        end        
#        return true
#    end
#    #如果是一个有效的、非空的图像文件，则返回true
#    def valid_file?
#        # 上传文件不是空的
#        if @image.size.zero?
#            errors.add_to_base("请选择头像！")
#            return false
#        end
#        unless @image.content_type =~ /^image/
#            errors.add(:image,"格式错误！")
#            return false
#        end
#        if @image.size > 1.megabyte
#             errors.add(:image,"不能超过1M！")
#        end
#        return true
#    end
#    private
#    def convert
#        if ENV["OS"] =~ /Windows/
#            # 指定windows平台中ImageMagick的正确位置
#            "C:\\Program Files\\ImageMagick-6.3.1-Q16\\convery"
#        else
#            "/usr/bin/convert"
#        end
#    end
end
