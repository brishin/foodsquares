require 'mongo_mapper'

Item.ensure_index :nid
Restaurant.ensure_index :menu