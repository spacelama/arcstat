#!/bin/sh

interval=${1:-5}        # 5 secs by default

while : ; do
    grep -e ^hits -e ^misses /proc/spl/kstat/zfs/arcstats | awk "{print \"arcstats.\"\$1\":\", \$3}"
    sleep $interval
done | awk '
       BEGIN {
               printf "%12s %12s %9s\n", "HITS", "MISSES", "HITRATE"
       }
       /hits/ {
               hits = $2 - hitslast
               hitslast = $2
       }
       /misses/ {
               misses = $2 - misslast
               misslast = $2
               rate = 0
               total = hits + misses
               if (total)
                       rate = (hits * 100) / total
               printf "%12d %12d %8.2f%%\n", hits, misses, rate
       }
'
