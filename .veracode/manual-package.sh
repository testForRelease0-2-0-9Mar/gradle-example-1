#!/bin/bash
set -e
shopt -s nullglob

pushd $(dirname "$0") >/dev/null 2>&1
repo_root=`git rev-parse --show-toplevel`
output_dir="$repo_root/.veracode/output/manual"
publishProject() {
    build_gradle_path="$1"

    if [ -d "$output_dir" ]; then
        echo Deleting $output_dir directory
        rm -rf $output_dir
    fi
    mkdir -p $output_dir
    echo Created $output_dir directory

    pushd $build_gradle_path >/dev/null 2>&1
        case "$OSTYPE" in
            darwin*)  ./gradlew clean build;;
            linux*)   ./gradlew clean build;;
            msys*)    gradlew clean build;;
            cygwin*)  gradlew clean build;;
        esac
        cp build/libs/*.{war,jar,ear} "$output_dir"
    popd
}

publishProject "$repo_root"
