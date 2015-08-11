class WUser < ActiveRecord::Base
  set_table_name :w_user
  attr_accessor :password_confirmation
end
