remotegitserver1=mysshgithost1
remotegitserver2=mysshgithost2

group=mygroup
subgroup=myrepos

repos=(
	my-repo
)


for repo in "${repos[@]}"; do
        echo "processing $repo"

        git clone -v --bare ssh://git@"$remotegitserver1"/~/"$subgroup"/"$repo"

        cd "$repo".git

        git remote rm origin2

        # Does this fetch new branches that might have been added in the meantime?
        # Alternatively delete the local repo, then run this script again
        # git fetch --all

        git remote add origin2 ssh://git@"$remotegitserver2"/"$group"/"$subgroup"/"$repo".git
        git push origin2 --all --force
        git push origin2 --tags

        cd ..
done
