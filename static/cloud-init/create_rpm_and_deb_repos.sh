#!/bin/bash

REPO="https://api.github.com/repos/EESSI/filesystem-layer/releases"
TMPDIR=$( mktemp -d )
APTLY="https://github.com/aptly-dev/aptly/releases/download/v1.4.0/aptly_1.4.0_linux_amd64.tar.gz"

RHEL_VERSIONS="8"
ARCHS="noarch" # x86_64 arm64 ppc64le"

cd $TMPDIR

# bzip2 is required by aptly
yum -y --quiet install bzip2

# Create repo trees
# http://url/reponame/rhel/$releasever/$basearch
for arch in $ARCHS; do
    mkdir -p /var/www/html/eessi/rhel/8/$arch
done

mkdir -p /var/www/html/eessi/deb

# We'll use repobuild to build rpm repo.
yum -y --quiet install createrepo

# We'll use aptly to create the deb repo.
[ -d /usr/local/bin ] || mkdir -p /usr/local/bin
if ! [ -f /usr/local/bin/aptly ]; then
    curl -L -O --silent $APTLY
    tar xzf /usr/local/bin/aptly_1.4.0_linux_amd64.tar.gz
    cp /usr/local/bin/aptly_1.4.0_linux_amd64/aptly /usr/local/bin
    rm -rf /usr/local/bin/aptly*
fi

mkdir packages;
cd packages;
rm -f *
# Fetch packages from the EESSI github repo
for url in $( curl --silent $REPO | grep -E 'browser_download_url.*(deb|rpm)' | grep -v latest | cut -f4 -d'"' );
    do curl -L -O --silent $url ;
done

# Create yum repo
for arch in $ARCHS; do
    cd /var/www/html/eessi/rhel/8/$arch
    cp -ua $TMPDIR/packages/*${arch}*.rpm .
    if [ -d repodata ];
    then
        createrepo -q --update .;
    else
        createrepo .
    fi
done

# Create debian repo
if ! /usr/local/bin/aptly repo show eessi 2>&1 > /dev/null; then
    /usr/local/bin/aptly repo create -distribution=sid -component=main eessi
fi
aptly repo add eessi $TMPDIR
aptly publish repo -skip-signing -architectures="all" eessi 2>&1 > /dev/null || /usr/local/bin/aptly publish repo -skip-signing -architectures="all" eessi sid > /dev/null

cp -ua /root/.aptly/public  /var/www/html/eessi/deb

rm -rf $TMPDIR
