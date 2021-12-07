cat repos/*/.git/config|grep url|cut -d= -f2
cat deps/*/*.json|grep repo|cut -d'"' -f4|sort -u

