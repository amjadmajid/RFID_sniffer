def hand_shake_timing():
	""" Get the timing between the last Query/QueryRep/QueryAdjust in the
		handshake and the following BlockWrite """
	hand_sh1ake_start=None
	hand_shake_end=None
	times = []
	for line in open('detail_messages.txt'):
		if line[0] == 'Q':
			hand_shake_start = line.split(':')[-2]
			if hand_shake_start == None:
				hand_shake_start=None
			else:
				time_start = int(hand_shake_start)
		
		elif line[0] == 'B' and hand_shake_start != None:
			hand_shake_end = line.split(':')[-2]
			if hand_shake_end == None:
				hand_shake_start=None
				hand_shake_end=None
				continue
			else:
				time_end = int(hand_shake_end)

			times.append( time_end - time_start)
			print(times[-1])
			hand_shake_start=None
			hand_shake_end=None

	print '----------------------------'
	print 'average handshake time-> ', (sum(times)/len(times))/25e3 , ' ms'
	print '----------------------------'
	print 'longest handshake-> ',max(times)/25e3 , ' ms'
	print '----------------------------'
	print 'shortest handshake-> ',min(times)/25e3 , ' ms'
	print '----------------------------'
	print 'length-> ',len(times)
	print '----------------------------'


def time_between_BW_TAG():
	""" """
	times=[]
	fh = open('detail_messages.txt')
	line = fh.readline()
	line2=None
	while line:
		if line[0] == 'B':
			line2 = fh.readline()
			if line2[0] == 'T':
				tag_start_time = line2.split(':')[-1]
				BW_end_time = line.split(':')[-2]
				if tag_start_time != None and BW_end_time != None:
					times.append(int(tag_start_time) - int(BW_end_time) )

		line = fh.readline()
	print '----------------------------'
	print 'average BW-Tag time-> ', (sum(times)/len(times))/25e3 , ' ms'
	print '----------------------------'
	print 'longest BW-Tag-> ',max(times)/25e3 , ' ms'
	print '----------------------------'
	print 'shortest BW-Tag-> ',min(times)/25e3 , ' ms'
	print '----------------------------'
	print 'length-> ',len(times)
	print '----------------------------'

def time_between_TAG_next_mes():
	""" """
	times=[]
	fh = open('detail_messages.txt')
	line = fh.readline()
	line2=None
	while line:
		if line[0] == 'T':
			line2 = fh.readline()
			tag_end_time = line.split(':')[-1]
			mes_start_time = line2.split(':')[-2]
			if tag_end_time != None and mes_start_time != None:
				times.append(int(mes_start_time) - int(tag_end_time) )

		line = fh.readline()
	print '----------------------------'
	print 'average BW-Tag time-> ', (sum(times)/len(times))/25e3 , ' ms'
	print '----------------------------'
	print 'longest BW-Tag-> ',max(times)/25e3 , ' ms'
	print '----------------------------'
	print 'shortest BW-Tag-> ',min(times)/25e3 , ' ms'
	print '----------------------------'
	print 'length-> ',len(times)
	print '----------------------------'




def main():
	#hand_shake_timing()
	#time_between_BW_TAG()
	time_between_TAG_next_mes()
if __name__=="__main__":
	main()
