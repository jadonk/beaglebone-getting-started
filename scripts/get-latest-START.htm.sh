#!/bin/sh
curl https://beagleboard.org/getting-started > START.htm
perl -pe 's#(["\x27])/([^"\x27])#$1https://beagleboard.org/$2#g' -i START.htm
perl -pe 's#(["\x27])https://beagleboard.org/static/Drivers/#$1Drivers/#g' -i START.htm
perl -pe 's#(["\x27])https://beagleboard.org/static/#$1static/#g' -i START.htm
perl -pe 's#<title>BeagleBoard.org - getting-started</title>#<title>Getting started with Beagle</title>#' -i START.htm
perl -pe 's#href="/"#href="https://beagleboard.org/"#g' -i START.htm
perl -pe 's#\r\n#\n#g' -i START.htm
cp START.htm README.htm
