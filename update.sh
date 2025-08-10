#!/bin/env bash
git submodule foreach 'branch=$(git config -f $toplevel/.gitmodules submodule.$name.branch); git checkout $branch; git pull origin $branch'
git submodule update --recursive --remote --force
