class LimitQueryController < ApplicationController
  def list
    et_now_t=Time.now
    #limit_date_30=et_now_t.months_since(1).to_date.to_s(:db)
    limit_date_30=et_now_t.since(3600 * 24 * 30).to_date.to_s(:db)
    limit_date_15=et_now_t.since(3600 * 24 * 15).to_date.to_s(:db)
    limit_date_5=et_now_t.since(3600 * 24 * 5).to_date.to_s(:db)
    limit_date_3=et_now_t.since(3600 * 24 * 3).to_date.to_s(:db)
    limit_date_now=et_now_t.to_date.to_s(:db)
    @case_now_3=TbCase.find(:all,:conditions=>"used='Y' and state>=4 and state<100 and clerk='#{session[:user_code]}' and finally_limit_dat>='#{limit_date_now}' and finally_limit_dat<'#{limit_date_3}'",:order=>"finally_limit_dat")
    @case_3_5=TbCase.find(:all,:conditions=>"used='Y' and state>=4 and state<100 and clerk='#{session[:user_code]}' and finally_limit_dat>='#{limit_date_3}' and finally_limit_dat<'#{limit_date_5}'",:order=>"finally_limit_dat")
    @case_5_15=TbCase.find(:all,:conditions=>"used='Y' and state>=4 and state<100 and clerk='#{session[:user_code]}' and finally_limit_dat>='#{limit_date_5}' and finally_limit_dat<'#{limit_date_15}'",:order=>"finally_limit_dat")
    @case_15_30=TbCase.find(:all,:conditions=>"used='Y' and state>=4 and state<100 and clerk='#{session[:user_code]}' and finally_limit_dat>='#{limit_date_15}' and finally_limit_dat<'#{limit_date_30}'",:order=>"finally_limit_dat")
  end
end
