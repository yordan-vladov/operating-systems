# 1
find ~ -type d -name "*test*"

# 2
find ~ -type f -name "*.js" | xargs wc -l

# 3
find ~ -type f -name "*.csv" -ls  2>/dev/null | sort -nr -k7,7 | head -n 1                                                                                                    130
