class Collaboration < ActiveRecord::Base

  belongs_to :app, class_name: "App",
             :dependent => :destroy

  validates :title, presence: true, length: {minimum: 3, maximum: 50}
  validates :baselang, presence: true, length: {minimum: 1, maximum: 50}
  validates :lang, presence: true, length: {minimum: 1}

end
