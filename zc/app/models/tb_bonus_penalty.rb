class TbBonusPenalty < ActiveRecord::Base
  validates_numericality_of :bonus ,:message => "奖励比例应为数字型"
  validates_numericality_of :penalty ,:message => "惩罚比例应为数字型"
  
  def self.add(recevice_code,typ,p)
    ccc=TbCase.find_by_recevice_code(recevice_code)
    bb=self.find(:first,:conditions=>"used='Y' and recevice_code='#{recevice_code}' and typ='#{typ}' and p='#{p}' ")
    if bb==nil
      bb=TbBonusPenalty.new()
      bb.used='Y'
      bb.recevice_code=ccc.recevice_code
      bb.case_code=ccc.case_code
      bb.general_code=ccc.general_code
      bb.typ=typ
      bb.p=p
      bb.view_num=1
    else
      bb.recevice_code=ccc.recevice_code
      bb.case_code=ccc.case_code
      bb.general_code=ccc.general_code
      bb.view_num=bb.view_num + 1
    end
    bb.save    
  end
  
  def self.del(recevice_code,typ,p)
    ccc=TbCase.find_by_recevice_code(recevice_code)
    bb=self.find(:first,:conditions=>"used='Y' and recevice_code='#{recevice_code}' and typ='#{typ}' and p='#{p}' ")
    if bb!=nil
      bb.view_num=bb.view_num - 1
      bb.recevice_code=ccc.recevice_code
      bb.case_code=ccc.case_code
      bb.general_code=ccc.general_code
      if bb.view_num<=0
        bb.used='N'
      end
      bb.save
    end 
  end
  
  def self.up_set(recevice_code,typ,p,rmb_typ,old_rmb,new_rmb) #rmb_typ  的类别 zc_rmb：仲裁报酬   gc_rmb:稿酬报酬  jh_rmb:校核报酬 
    ccc=TbCase.find_by_recevice_code(recevice_code)
    bb=self.find(:first,:conditions=>"used='Y' and recevice_code='#{recevice_code}' and typ='#{typ}' and p='#{p}' ")
    if bb!=nil
      bb.recevice_code=ccc.recevice_code
      bb.case_code=ccc.case_code
      bb.general_code=ccc.general_code
      if rmb_typ=='zc_rmb'
        bb.zc_rmb=bb.zc_rmb + new_rmb - old_rmb
      elsif rmb_typ=='gc_rmb'
        bb.gc_rmb=bb.gc_rmb + new_rmb - old_rmb
      elsif rmb_typ=='jh_rmb'
        bb.jh_rmb=bb.jh_rmb + new_rmb - old_rmb
      end
      bb.save
    end 
  end

  # 注意 ：只有删除 某一种报酬的时候才可以执行 本方法，如果是更新则只能用up_set方法，因为本方法会将 view_num 的字段值减 1
  def self.del_set(recevice_code,typ,p,rmb_typ,rmb) #rmb_typ  的类别 zc_rmb：仲裁报酬   gc_rmb:稿酬报酬  jh_rmb:校核报酬 
    ccc=TbCase.find_by_recevice_code(recevice_code)
    bb=self.find(:first,:conditions=>"used='Y' and recevice_code='#{recevice_code}' and typ='#{typ}' and p='#{p}' ")
    if bb!=nil
      bb.view_num=bb.view_num - 1
      bb.recevice_code=ccc.recevice_code
      bb.case_code=ccc.case_code
      bb.general_code=ccc.general_code
      
      if rmb_typ=='zc_rmb'
        bb.zc_rmb=bb.zc_rmb - rmb
      elsif rmb_typ=='gc_rmb'
        bb.gc_rmb=bb.gc_rmb - rmb
      elsif rmb_typ=='jh_rmb'
        bb.jh_rmb=bb.jh_rmb - rmb
      end
      
      if bb.view_num<=0
        bb.used='N'
      end
      
      bb.save
    end 
  end
  
#  计算方法：
#  基本报酬的数额＝（庭审和调解＋阅卷＋仲裁费）的数额
#  稿酬的数额＝（裁决书和管辖决定等的起草和修改以及修改情况说明）的数额总和
  
end
