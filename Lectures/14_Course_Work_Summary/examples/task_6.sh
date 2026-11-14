# 1
find ~ -type d -name "*test*" | wc -l

# 2
find ~ -type f -name "*.js" | xargs cat | wc -l

# 3
find ~ -type f -name "*.csv" -ls 2>/dev/null | sort -n -k7,7 | head -n 1
