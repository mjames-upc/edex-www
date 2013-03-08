#!/usr/bin/python
import time
import calendar
import sys
import datetime

lastTime = ''

# sys.argv[1] = <script>.csh
# sys.argv[2] = feed/product name (e.g. "gfsP5")
# sys.argv[3] = hex color (e.g. "#ecc306")

sys.stdout.write( '"' + sys.argv[2]  + '": { label: "' + sys.argv[2]  + '", color: "#' + sys.argv[3] + '", data: [ ' )

first_line = 0
logname = sys.argv[1]
f = open(logname,'r')
for line in f:
	lineContent = line.split()
	lineContent[1] = lineContent[1][0:6].replace(':','')
	lineContent[2] = lineContent[2].replace(',','')
	if lineContent[1] != lastTime:
		lastTime = lineContent[1]
		datestr = lineContent[0] + ' ' + lineContent[1]
		s = datetime.datetime.strptime(datestr, "%Y-%m-%d %H%M")
		lineContent[0] = calendar.timegm(s.timetuple())
		sys.stdout.write('[' + str(lineContent[0]*1000) + ', ' + lineContent[2] + '],')
f.close()
sys.stdout.write( ']},' )
