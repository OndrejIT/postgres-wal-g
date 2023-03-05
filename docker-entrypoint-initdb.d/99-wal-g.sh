#!/usr/bin/env bash

WALG_PROFILE=${WALG_PROFILE:-devel}


tee -a "${PGDATA}/postgresql.conf" <<EOF


#------------------------------------------------------------------------------
# DATABASE BACKUP
#------------------------------------------------------------------------------

EOF

if [ "${WALG_PROFILE}" == "prod" ]; then
	tee -a "${PGDATA}/postgresql.conf" <<EOF
archive_mode = on
EOF

else

	tee -a "${PGDATA}/postgresql.conf" <<EOF
# Disabled in devel or restore mode
#archive_mode = on
archive_mode = off
EOF

fi

tee -a "${PGDATA}/postgresql.conf" <<EOF
archive_command = '/usr/local/bin/backup %p'
archive_timeout = 1200
wal_level = logical

##### Recovery #####
restore_command = '/usr/local/bin/wal-g wal-fetch %f %p'

recovery_target_action = 'promote'
recovery_target_timeline = 'latest'

EOF
