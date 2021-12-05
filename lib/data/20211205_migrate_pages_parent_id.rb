# run with
# 	rails runner lib/data/20211205_migrate_pages_parent_id.rb

pp Page.all.map{ |page| [page.id, page.parent_id] }

Page.all.each do |page|
	page.parent_id = page.parent_page.id if page.has_parent?
	page.save
end

pp Page.all.map{ |page| [page.id, page.parent_id] }
