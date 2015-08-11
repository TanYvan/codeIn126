class Remind < ActiveRecord::Base
  validates_presence_of :contents ,:message => "请填写提醒内容"
  
  def before_create
    suppress(ActiveRecord::StatementInvalid) do 
      ActiveRecord::Base.connection.execute 'SET NAMES utf8'
    end
  end
  
  def before_save
    suppress(ActiveRecord::StatementInvalid) do 
      ActiveRecord::Base.connection.execute 'SET NAMES utf8'
    end
  end
  
  def before_update
    suppress(ActiveRecord::StatementInvalid) do 
      ActiveRecord::Base.connection.execute 'SET NAMES utf8'
    end
  end
end
