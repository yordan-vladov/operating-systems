echo "first second" | sed 's/\(first\) \(second\)/\2 \1/'
# Output: second first

echo "This is an example" | sed 's/\(example\)/(\1)/'
# Output: This is an (example)

echo "2023-11-02" | sed 's/\(....\)-\(..\)-\(..\)/\2\/\3\/\1/'
# Output: 11/02/2023

echo "Alice Smith" | sed 's/\([A-Za-z]*\) \([A-Za-z]*\)/\2, \1/'
# Output: Smith, Alice
