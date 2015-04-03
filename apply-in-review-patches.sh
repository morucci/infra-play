set -xe

target=$1
# Here are some refactoring patch waiting for review I apply
patches="refs/changes/30/168330/2 refs/changes/46/167646/2 refs/changes/88/167288/1 refs/changes/87/170487/1"

# This script is run by cron and reset the git repo (skip that)
echo "" > /opt/system-config/production/run_all.sh
cp /root/site.pp $1/manifests/

cd $1

git fetch origin
git reset --hard origin/master

for p in $patches; do
    git fetch https://review.openstack.org/openstack-infra/system-config $p && git cherry-pick FETCH_HEAD
done
cd -

