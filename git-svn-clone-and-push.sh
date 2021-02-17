#!/bin/sh

# This script will clone remote SVN repositories as local git repositories using git-svn (https://git-scm.com/docs/git-svn)
# and push them to a remote git server. 
# Expects empty git repositories on the remote git server to be initialized previously.

# Execute this script in a directory where to create the cloned git repos locally.
# Runs against all SVN repos inside reponame and named like those in repos array

# Requires a file svn-users.txt to be existent which contains a mapping of SVN users to git user names.

# safety exit
exit 0

reponame="repositories"

repos=(
common-repo-1
common-repo-2
)

for i in "${repos[@]}"; do
    echo "processing $i"
    
git svn clone http://localhost/svn/"$reponame"/"$i" --authors-file=svn-users.txt --no-metadata --prefix "" -s "$i"
    
    cd "$i"
    
    for t in $(git for-each-ref --format='%(refname:short)' refs/remotes/tags); do git tag ${t/tags\//} $t && git branch -D -r $t; done
    
    for b in $(git for-each-ref --format='%(refname:short)' refs/remotes); do git branch $b refs/remotes/$b && git branch -D -r $b; done
    
    for p in $(git for-each-ref --format='%(refname:short)' | grep @); do git branch -D $p; done
    
    git branch -d trunk
    
    git remote add origin git@remotegitserver:~/"$reponame"/"$i"
    
    git push origin --all
    
    git push origin --tags

    cd ..
done
