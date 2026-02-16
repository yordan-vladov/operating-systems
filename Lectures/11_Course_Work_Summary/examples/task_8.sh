# Create an archive named "etc_backup.tar" from all files and directories in the "/etc" directory
tar -cvf etc_backup.tar /etc

# Unzip the "etc_backup.tar" archive to the current directory
tar -xvf etc_backup.tar

# Add all files with the extension ".md" from the current directory to the "etc_backup.tar" archive
tar -rvf etc_backup.tar *.md

# List all files and directories in the "etc_backup.tar" archive
tar -tvf etc_backup.tar

# List all files in the "project_backup.tar" archive that contain "task" in their name
tar -tvf project_backup.tar | grep 'task'
