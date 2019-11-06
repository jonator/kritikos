#!/bin/sh

./rel/deployable/bin/deployable eval "Kritikos.ReleaseTasks.migrate_database" && \
./rel/deployable/bin/deployable start
