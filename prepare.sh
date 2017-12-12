#!/bin/sh

current_pwd="$PWD"
project_dir=`cd "../../"; pwd`
cd "$current_pwd"
project_file=`find "$project_dir" -maxdepth 1 -name "*.xcodeproj" | tail -1`

echo $project_file

ruby prepare.rb $project_file

