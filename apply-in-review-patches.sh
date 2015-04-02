set -xe

target=$1
# Here are some refactoring patch waiting for review I apply
patches="refs/changes/30/168330/2 refs/changes/46/167646/2 refs/changes/88/167288/1"

cd $1

git fetch origin
git reset --hard origin/master

for p in $patches; do
    git fetch https://review.openstack.org/openstack-infra/system-config $p && git cherry-pick FETCH_HEAD
done
cd -
