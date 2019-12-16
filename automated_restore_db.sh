#!/bin/bash

cd dbs/

wget -O $1 $2

name=$(echo "$1" | cut -f 1 -d '.')

createdb "${name%.*}_org"

if [ "${1##*.}" = "gz" -o "${1##*.}" = "zip" ];
then
     cat $1 | gunzip -d | pg_restore -O -x -d ${name%.*}_org
    # cat $1 | gunzip -d | ../migration-scripts/tools/sql_db_filter.pl| psql "${name%.*}_org"

elif [ "${1##*.}" = "tar.gz" ];
then
	cat $1 | gzip -d | pg_restore -O -x -d ${name%.*}_org
	#cat $1 | gzip -d | ../migration-scripts/tools/sql_db_filter.pl| psql "${name%.*}_org"

elif [ "${1##*.}" = "xz" ];
then
	cat $1 | xz -d | pg_restore -O -x -d ${name%.*}_org
	#cat $1 | xz -d | ../migration-scripts/tools/sql_db_filter.pl| psql "${name%.*}_org"

else [ "${1##*.}" = "dump" ];
	pg_restore -O -x -d ${name%.*}_org < $1

fi

echo "Database successfully created:"
echo "${name%.*}_org"

