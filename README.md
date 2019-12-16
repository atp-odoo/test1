#!/bin/bash

cd dbs/

wget -O $1 $2

createdb "${1%.*}_mgt"

if [ "${1##*.}" = "gz" -o "${1##*.}" = "zip" ];
then
     cat $1 | gunzip -d | ../migration-scripts/tools/sql_db_filter.pl| psql "${1%.*}_mgt"

elif [ "${1##*.}" = "tar.gz" ];
then
	cat $1 | gzip -d | ../migration-scripts/tools/sql_db_filter.pl| psql "${1%.*}_mgt"
elif [ "${1##*.}" = "xz" ];
then
	cat $1 | xz -d | ../migration-scripts/tools/sql_db_filter.pl| psql "${1%.*}_mgt"
else [ "${1##*.}" = "dump" ];

	cat $1 | pg_restore -d | ../migration-scripts/tools/sql_db_filter.pl| psql "${1%.*}_mgt"
fi

echo "Database successfully created:"
echo "${1%.*}_mgt"



