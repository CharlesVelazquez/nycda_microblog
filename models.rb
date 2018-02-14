class User < ActiveRecord::Base
	validates :username, uniqueness: true, presence: true
	has_many :posts, dependent: :destroy
end

class Post < ActiveRecord::Base
	belongs_to :user
end