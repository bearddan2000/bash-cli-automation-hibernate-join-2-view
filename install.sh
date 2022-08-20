#!/usr/bin/env bash

# folder.sh
function folder() {
  #statements
  local file=$1
  local new_folder=`head -n 1 $file/README.md | sed 's/# //g'`

  mv $file $new_folder
}
# readme.sh
# 1. change word join to view
# 2. add description
function replace_readme_str() {
  #statements
  local file=$1/README.md
  local old=$2
  local new=$3

  perl -pi.bak -e "s/${old}/${new}/" $file
  rm -f $1/README.md.bak
}
function readme() {
  #statements
  local file=$1
  read -r -d '' DESCRIPTION <<EOF
Add an immutable entity \`breedcount\` as a view uses a subquery join.

## Tech stack
EOF

  replace_readme_str $file "join" "view"

  replace_readme_str $file "## Tech stack" "$DESCRIPTION"
}
# build.sh
# 1. add file BreedCount
# 2. add file  BreedCountEntity
# 2. update file Main
# 3. update file hibernate.cfg.xml
function build() {
  #statements
  local file=$1

  for e in `find $file -type d -name src`; do
    #statements
    cp .src/BreedCount.java $e/main/java/example/dto/BreedCount.java

    cp .src/BreedCountEntity.java $e/main/java/example/entity/BreedCountEntity.java

    cp .src/Main.java $e/main/java/example/Main.java

    ./src/fix.py $e/main/resources/hibernate.cfg.xml
  done
}

# install.sh
function install() {
  #statements
  local file=$1

  build $file

  readme $file

  folder $file
}

for d in `ls -la | grep ^d | awk '{print $NF}' | egrep -v '^\.'`; do
  install $d
done
