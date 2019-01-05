class PtnsMmb < ApplicationRecord
	before_save :upcase_all

	private

	def upcase_all
		self.name = self.name.upcase
		self.add1 = self.add1.upcase
		self.add2 = self.add2.upcase
		self.city = self.city.upcase
		self.state = self.state.upcase
		self.ts_name = self.ts_name.upcase
		self.ts_add1 = self.ts_add1.upcase
		self.ts_add2 = self.ts_add2.upcase
		self.ts_city = self.ts_city.upcase
		self.ts_state = self.ts_state.upcase
		self.ts_status = self.ts_status.upcase
		self.ts_owner = self.ts_owner.upcase
		self.ts_job = self.ts_job.upcase
	end

end
