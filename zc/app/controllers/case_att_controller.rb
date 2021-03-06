class CaseAttController < ApplicationController
  def list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @typ = AttachmentConfig.find(:all)
      @att_typ = {}
      @typ.each{|ari|
        @att_typ.merge!({ari.code => ari.name})
      }
      @user_typ = {"arbitman"=>"仲裁员","party"=>"当事方","assintant"=>"办案助理"}
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      @att=CaseAtt.find_by_sql("select attachment.id as att_id,attachment.category as category,attachment.file_name as file_name,case_att.u_typ as u_typ,case_att.u as u,case_att.u_t as u_t,attachment.description as description,attachment.remark as remark  from case_att,attachment where case_att.recevice_code='#{session[:recevice_code]}' and case_att.used='Y' and case_att.att_id=attachment.id order by case_att.u_t desc")
    end
  end
  def down
    if TbCase.find_by_recevice_code(CaseAtt.find_by_att_id(params[:id]).recevice_code).clerk==session[:user_code]
      att = Attachment.find(params[:id])
      if att.file_path.blank?
        fd = Extranet::FileDown.new
        path =fd.down(att)
        att.file_path = path
        att.file_url = path
        att.save
      end

      send_file( AttachmentConfig.find_by_code(att.category).network_dir + att.file_path)
    end
  end
end
