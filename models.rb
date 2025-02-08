require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_secure_password
    has_many :portfolios
    has_many :items
    has_many :posts
end


class Item < ActiveRecord::Base
    belongs_to :portfolio
    belongs_to :user
end


class Post < ActiveRecord::Base
    belongs_to :portfolio
    belongs_to :user
end


class Portfolio < ActiveRecord::Base
    has_many :posts
    belongs_to :user
end
