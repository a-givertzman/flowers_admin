#!/bin/bash
NC='\033[0m'
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green

targetUser='root'
targetHost='95.142.42.240'
targetPath='/var/www/html/'

echo -e 'Clearing build/web/ ...'
rm -r build/web/

echo -e 'Building web app ...'
flutter build web --release

echo -e "Clearing target '$targetHost:$targetPath' ..."
ssh $targetUser@$targetHost "rm -rf $targetPath"

echo -e 'Coping new files '$targetHost:$targetPath' ...'
rsync -avz -e 'ssh' build/web/ $targetUser@$targetHost:$targetPath

echo -e "Deploy done to '$targetHost:$targetPath'"
