mkdir projects/backup
find projects -name "*.py" | xargs -I {} cp {} projects/backup

mkdir projects/src/utils
find projects -type f -name "*utils*" | xargs -I {} mv {} projects/src/utils

cd projects
rm *.??
