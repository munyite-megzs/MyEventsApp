class Event < ActiveRecord::Base
		     extend FriendlyId
		     friendly_id :slug_candidates, use: :slugged
		 
			 belongs_to :organizers, class_name: "User"
			 has_many :taggings
			 has_many :tags, through: :taggings

		 def slug_candidates
				[
				:title,
				[:title, :location],
				]
		end


		def all_tags
			 tags.map(&:name).join(", ")
		end

		def all_tags=(names)
             self.tags = names.split(",").map do |t|
             	#searches the db to se whether it is there if not it adds it
             Tag.where(name: t.strip).first_or_create!
             end
         end


         def self.tagged_with(name)
			 Tag.find_by_name!(name).events
		end

		def self.tag_counts
              Tag.select("tags.name, count(taggings.tag_id) as count").joins(:taggings).group("taggings.tag_id")
        end

end
