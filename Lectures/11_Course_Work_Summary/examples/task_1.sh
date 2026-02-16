# make file structure
mkdir projects
touch projects/README.md
touch projects/main.py
mkdir projects/data/
touch projects/data/input.csv
touch projects/data/data.csv
mkdir projects/src
touch projects/src/utils.py
mkdir projects/src/helpers
touch projects/src/helpers/helper_functions.py
tree projects

# delete src/helpers
rm -rf projects/src/helpers
tree projects
