class Language < ActiveRecord::Base
  belongs_to :app, class_name: "App",
             :dependent => :destroy
end