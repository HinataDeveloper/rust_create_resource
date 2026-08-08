#!/usr/bin/env zsh

cp --update=none -v src/main.rs src/main_$1.rs
cp mp.rs src/main.rs
git add --all
git commit -m 'new Rust Sample code for box smart pointers'
git status
