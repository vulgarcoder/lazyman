require 'lazyman/errors'
module Lazyman
	class Page
		include PageObject

		def method_missing(m, *args, &blk)
			if @browser.respond_to? m
				@browser.send(m, *args, &blk)
			else
				super
			end #if
		end

		def turn_to kls
			raise InvalidLazymanPageError unless kls <= Lazyman::Page
			kls.new(@browser)
		end

		def data_driven hash
			raise ArgumentError unless hash.is_a?(Hash)
			hash.each do |mtd, data|
				m_with_eql = (mtd.to_s + '=').to_sym
				if respond_to?(m_with_eql)
					#self.send(m_with_eql, data)
					eval "self.#{m_with_eql.to_s}(data)"
				elsif respond_to?(mtd.to_sym)
					if(data.nil?||data.empty?) then
						self.send(mtd.to_sym)
					else
						self.send(mtd.to_sym).send(data.to_sym)
					end
				end #if
			end #each
			yield(self) if block_given?
		end

	end #Page

end #Lazyman
