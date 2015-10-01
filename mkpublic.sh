if [[ -n $1 && -n $2 ]]; then 
rsync -catv $1 $2 | grep -v ^sending | grep -v ^sent | grep -v ^total | egrep -v '^ *$'
else
echo Usage $0 SOURCE-FILE DESTINATION-FILE
fi
