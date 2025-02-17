#!/bin/bash -ue
cowsay -c "cow" -t "$(cat output-Hello.txt)" > cowsay-output-Hello.txt
