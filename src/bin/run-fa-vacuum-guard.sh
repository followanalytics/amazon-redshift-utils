#!/usr/bin/env bash

set -e

echo "Running FollowAnalytics analyze-vacuum GUARD utility"

# Required
REDIS_URL=${REDIS_URL:-}

REDIS="redis-cli"
LOCK_KEY="locking:tasks:solo:RedAggregateDevicesAndUsersJob"
BREAK_ON="1"

REDIS_CMD="$REDIS -u $REDIS_URL"
RELEASE_CMD="echo \"DEL $LOCK_KEY\" | $REDIS_CMD"

tryLock () {
  local redis_order="SETNX $LOCK_KEY `date -u +"%Y-%m-%dT%H:%M:%SZ"` EX 1200"
  local cmd="echo \"$redis_order\" | $REDIS_CMD"
  local result=$(eval $cmd)
  echo $result
}

echo "Waiting for lock on $LOCK_KEY from redis $REDIS_URL"
for (( ; ; ))
do
  TRYLOCK="$(tryLock)"
  echo $TRYLOCK
  if [ "$TRYLOCK" == "$BREAK_ON" ]
  then
    echo "Lock acquired"
    bin/run-analyze-vacuum-utility.sh
    echo "Vacuum done. Release lock"
    $(eval $RELEASE_CMD)
    break
  fi
  echo "Waiting"
  sleep 2
done
