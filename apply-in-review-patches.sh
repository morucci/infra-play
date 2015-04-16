set -xe

target=$1
action=$2

# Here are some refactoring patch waiting for review I apply
# You should need to manually fix some merge conflict, in that
# case comment the following lines if some of them has beeen
# applied.
patches=""
patches="$patches refs/changes/30/168330/3"
patches="$patches refs/changes/46/167646/2"
patches="$patches refs/changes/88/167288/1"
patches="$patches refs/changes/87/170487/4"

function reset {
  cd $target
  git fetch origin
  git reset --hard origin/master
  # This script is run by cron and reset the git repo (skip that)
  echo "" > run_all.sh
  git add run_all.sh
  git commit -m"Empty run_all.sh to prevent cron"
  cd -
}

function apply {
  cd $target
  for p in $patches; do
    git fetch https://review.openstack.org/openstack-infra/system-config $p && git cherry-pick FETCH_HEAD
  done
  cp /root/site.pp manifests/
  cd -
}

if [ "$action" = "reset" ]; then
  reset
fi
if [ "$action" = "apply" ]; then
  apply
fi
