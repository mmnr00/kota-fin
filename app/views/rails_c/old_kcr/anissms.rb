a=["016-3492196",	"012-3200425",	"011-15196135",	"017-6503932",	"014-6414732",	"019-5925007",	"019-2994427",	"011-27644481",	"014-8074453",	"012-6304109",	"018-2237389",	"017-3745293",	"011-61825113",	"017-3196177",	"017-2186251",	"017-3232931",	"011-27412184",	"016-3276561",	"016-7643749",	"012-3506630",	"017-4750977"]
tchd = Tchdetail.where(name: a)
tchd.count

a.each do |tc|
@client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_KEY"])
@client.messages.create(
	#to: "+60174151556", 
	to: "+6#{tc[0..2]}#{tc[4..20]}", 
	from: ENV["TWILIO_PHONE_NO"], 
	body: "\n Terima kasih kerana mendaftar untuk Program Bengkel Cikgu Ank Istimewa Selangor (ANiS)
	\n Tahniah! anda telah di senarai pendek untuk  mengikuti program Bengkel Cikgu Anis Siri 8/2019 . Untuk makluman, program seterusnya akan diadakan pada: 
	\n 18-20 Oktober 2019 (Jumaat - Ahad) Hotel Sri Bayu Bagan Lalang, Sepang
	\n SEGERA klik dan sertai Whatsapp group ini
	\n https://chat.whatsapp.com/Dctm48vYK7lJoAVKcucU2Z  
	\n Jika anda BERMINAT  untuk menyertai bengkel  ( feedback dalam masa 24jam dari tarikh anda terima pesanan SMS ini) 
	\n Sila abaikan pesanan SMS  ini jika anda tidak lagi berminat menyertai bengkel ini.
	\n TEMPAT ADALAH AMAT TERHAD. HUBUNGI KAMI SEGERA!!
	\n Terima kasih atas kerjasama anda. Sebarang pertanyaan sila hubungi Pn. Zaiha 013-6689376
	"
)
end
