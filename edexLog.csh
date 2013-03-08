#!/bin/csh
set DATE=`date +%Y%m%d`
set DATEU=`date -u +%Y%m%d`
set LOGS=/awips2/edex/logs
set WORK=/usr/local/mj/live
echo -n "var datasets = {" > $WORK/js/live.js

# get all NGRID
grep "processed in" $LOGS/edex-ingestGrib-${DATE}.log | grep -v GRID004 | grep -v GRID000 | awk '{print $2, $3, $16, $13}' | grep -v INFO | grep -v Could | grep -v java > $WORK/proc.log
if (`cat $WORK/proc.log | wc -l` > 0) then
  python $WORK/edexLog.py $WORK/proc.log ngrid 56a73d >> $WORK/js/live.js
endif
rm $WORK/proc.log

# get CONDUIT gfsP5 from ingestGrib 
grep "processed in" $LOGS/edex-ingestGrib-${DATE}.log | grep GRID004 | awk '{print $2, $3, $16, $13}' | grep -v INFO | grep -v Could | grep -v java > $WORK/proc.log
if (`cat $WORK/proc.log | wc -l` > 0) then
  python $WORK/edexLog.py $WORK/proc.log gfsP5 b1d8fb >> $WORK/js/live.js
endif
rm $WORK/proc.log

# get CONDUIT 2.5deg from ingestGrib
grep "processed in" $LOGS/edex-ingestGrib-${DATE}.log | grep GRID000 | awk '{print $2, $3, $16, $13}' | grep -v INFO | grep -v Could | grep -v java > $WORK/proc.log
if (`cat $WORK/proc.log | wc -l` > 0) then
  python $WORK/edexLog.py $WORK/proc.log gfs25 c74d49 >> $WORK/js/live.js
endif
rm $WORK/proc.log

# get Radar
grep "processed in" $LOGS/edex-ingest-radar-${DATEU}.log | awk '{print $2, $3, $16, $13}' | grep -v INFO | grep -v Could | grep -v java > $WORK/proc.log
set lc=`cat $WORK/proc.log | wc -l`
if (`cat $WORK/proc.log | wc -l` > 0) then
  python $WORK/edexLog.py $WORK/proc.log nexrad3 8e3bf5 >> $WORK/js/live.js
endif
rm $WORK/proc.log

# get Satellite
grep "processed in" $LOGS/edex-ingest-satellite-${DATEU}.log | awk '{print $2, $3, $16, $13}' | grep -v INFO | grep -v Could | grep -v java > $WORK/proc.log
if (`cat $WORK/proc.log | wc -l` > 0) then
  python $WORK/edexLog.py $WORK/proc.log nimage bc9c0a >> $WORK/js/live.js
endif
rm $WORK/proc.log

# get text
grep "processed in" $LOGS/edex-ingest-text-${DATEU}.log | awk '{print $2, $3, $16, $13}' | grep -v INFO | grep -v Could | grep -v java > $WORK/proc.log
if (`cat $WORK/proc.log | wc -l` > 0) then
  python $WORK/edexLog.py $WORK/proc.log text 8eacc9 >> $WORK/js/live.js
endif
rm $WORK/proc.log

# get ingest
grep "processed in" $LOGS/edex-ingest-${DATE}.log | awk '{print $2, $3, $16, $13}' | grep -v INFO | grep -v Could | grep -v java > $WORK/proc.log
if (`cat $WORK/proc.log | wc -l` > 0) then
  python $WORK/edexLog.py $WORK/proc.log ingest ecc306 >> $WORK/js/live.js
endif
rm $WORK/proc.log

echo -n "};" >> $WORK/js/live.js

scp $WORK/js/live.js conan:/content/staff/mjames/awips2/
exit()

