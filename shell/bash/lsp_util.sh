#!/bin/env bash

filename=$1
lang=$2
tempFile="$filename"."$lang"

function moveTemp {
    cp "$filename" /tmp/"$tempFile" && chmod -w /tmp/"$tempFile" && nvim /tmp/"$tempFile"
}

moveTemp
exit
