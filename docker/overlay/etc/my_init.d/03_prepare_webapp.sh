#!/usr/bin/env bash

cd /home/app/webapp

RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:setup

chown -R app:app /home/app/webapp/tmp/cache

echo
echo
echo -e "\e[32m*****************************************"
echo -e "\e[32m*                                       *"
echo -e "\e[32m*  \e[0m👉 Now open http://localhost:3000 👈 \e[32m*"
echo -e "\e[32m*                                       *"
echo -e "\e[32m*****************************************"
echo -e "\e[0m"
echo
echo