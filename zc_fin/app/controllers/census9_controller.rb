#2009-7-15   niell    仲裁庭统计
class Census9Controller < ApplicationController
  def list9
    j = params[:j]
    @date1=params[:date1]
    @date2=params[:date2]
    if @date2==nil and @date1==nil
      @date1=Date.today
      @date2=Date.today
    end
    if j!=nil
      room = params[:j][:room]
    end
    @sittingroom=TbDictionary.find(:all,:conditions=>"typ_code='0023' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_text,data_val")
    @style1=TbDictionary.find(:all,:conditions=>"typ_code='0028' and data_val<>'0000'",:order=>'data_val',:select=>"data_val,data_text")
  end
end
