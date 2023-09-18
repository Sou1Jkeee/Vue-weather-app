#!/usr/bin/env sh

set -e
# deploy main branch
git add -A
git commit -m 'deploy'
git push -f git@github.com:Sou1Jkeee/vue-weather-app.git main:main

npm run build

cd dist/

# add CNAME file
# echo 'vueweatherapp.site' > CNAME

# deploy gh-pages branch
git init
git add -A
git commit -m 'deploy'
git branch -M gh-pages
git push -f git@github.com:Sou1Jkeee/vue-weather-app.git gh-pages:gh-pages

cd -
