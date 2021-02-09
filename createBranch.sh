branchName=$1
# Branch erstellen local
git checkout -b $branchName

# branch auf den server pushen
git push -u origin $branchName
