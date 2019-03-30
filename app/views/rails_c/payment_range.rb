@taska = Taska.find(52)
mth = 4
year = 2019
dt = Time.find_zone("Singapore").local(year,mth)
payment = @taska.payments.where.not(name: "TASKA PLAN")
curr_pmt = payment.where(bill_month: mth).where(bill_year: year)
pmt_paid = curr_pmt.where(paid: true)
cdtn_1=pmt_paid.where("updated_at < ?", dt)

n=0
(1..12).each do |m|
n=n+1
end