#!/bin/bash

for N in $(seq 24)
do
    	diff "../writeup/runtime/pp_1.txt" "../writeup/runtime/pp_"${N}".txt"
done

