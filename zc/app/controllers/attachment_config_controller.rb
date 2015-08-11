class AttachmentConfigController < ApplicationController

  def list
    @att = AttachmentConfig.find(:all,:order=>'code')
  end

end
