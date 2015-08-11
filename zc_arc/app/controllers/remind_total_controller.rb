class RemindTotalController < ApplicationController
  def list
    @remind=Remind.find_by_sql("select users.code as code,users.name as name,count(reminds.uu) as c from reminds,users where users.used='Y' and reminds.used='Y' and users.code=reminds.uu and (reminds.state=1 or reminds.state=2) and reminds.dt1<='#{Date.today.to_s(:db)}' group by users.code order by users.ord")
  end
end
