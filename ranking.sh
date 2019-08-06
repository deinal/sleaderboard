#!/bin/bash

users=$(squeue | awk '{print $2}' | sort | uniq | grep -v USER)

tot=$(squeue | wc -l)
tot=$((tot-1))

for u in $users; do  
  use=$(squeue -u $u | wc -l)
  use=$((use-1))
  percent=$(bc <<<"scale=2;100.0*$use/$tot")
  percent=$(printf "%3.2f" $percent)
  stats=$stats"$use \t $percent \t $u \n"
done

echo "--- Slurm Leaderboard, tot: $tot ---"
echo -e "pos \t jobs \t % \t user" 

sorted=$(echo -e $stats | sort -nr)
n=1
while read -r line; do
  echo -e "$n \t $line"
  n=$((n+1))
done <<< "$sorted"
