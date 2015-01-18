Checking number of current connections
--------------------------------------

A simple way to check the number of current connections is using `lsof`. Be sure to
set the right path to garufa.pid file.


``` console
while :; do echo "$(date '+%H:%M:%S') $(sudo lsof -p `cat /path/to/garufa.pid` | grep ESTABLISHED | wc -l)"; sleep 1; done;
```
