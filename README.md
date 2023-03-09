# How to configure automatic backup and restore
### Please read this: https://github.com/wal-g/wal-g/blob/master/docs/PostgreSQL.md

## You need to configure the environment:
- AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, WALG_PROFILE (prod, dev, or restore) and WALG_S3_PREFIX

    - WALG_PROFILE=restore # Automatic postgresql restore
    - WALG_PROFILE=dev # pass - for devel
    - WALG_PROFILE=prod # Automatic postgresql backup

## You also need to configure cron to run a basebackups
# Cron - sample usage
    # Postgres
    50 */6 * * *   root    /usr/bin/docker exec postgres /usr/local/bin/backup basebackup && curl -fsS --retry 3 https://healthchecks.sample.com/ping/xxx-xxx > /dev/null
    # Postgres basebackups cleaner
    0 16 * * 1,3   root    /usr/bin/docker exec postgres wal-e delete --confirm retain 12 && curl -fsS --retry 3 https://healthchecks.sample.com/ping/yyy-yyy > /dev/null


# How to clean your backups
    wal-g backup-list
    wal-g delete --confirm retain 3


# Useful
- https://postgres.cz/wiki/Instalace_PostgreSQL#Instalace_Fulltextu
