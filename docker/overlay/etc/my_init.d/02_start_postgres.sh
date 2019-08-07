#!/usr/bin/env bash
set -e


# Check if initialized
if [[ ! -f /var/lib/postgresql/initialized ]]; then
    echo 'Initializing database...'
    rm -rf /var/lib/postgresql/*
    su postgres -c "/usr/lib/postgresql/10/bin/initdb -D /var/lib/postgresql/10/main"
    chown postgres /var/lib/postgresql/10 -R
    if /etc/init.d/postgresql start ; then
        psql -U postgres --command "CREATE USER \"$DB_USER\" WITH SUPERUSER PASSWORD '$DB_PASSWORD';"
        createdb -U postgres -O "$DB_USER" "$DB_NAME"
        cd /home/app/webapp
        su app -c "RAILS_ENV=production bin/rake db:schema:load"
        touch /var/lib/postgresql/initialized
    fi
fi

chown postgres /var/lib/postgresql -R

/etc/init.d/postgresql start
