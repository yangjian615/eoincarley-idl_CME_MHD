pro archive_pngs

;run every night on grian

cd,'~/rsto/pngs/'

get_utc,ut
today=time2file(ut,/date)
spawn,'mkdir '+today

cd,'~/rsto/pngs/'+today
spawn,'mkdir high_freq'
spawn,'mkdir low_freq'

cd,'~/rsto/pngs/realtime/high_freq'
spawn,'mv *.png ~/rsto/pngs/'+today+'/high_freq'

cd,'~/rsto/pngs/realtime/low_freq'
spawn,'mv *.png ~/rsto/pngs/'+today+'/low_freq'

END