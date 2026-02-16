# static prompt
PS1=">"

# basic prompt
# %n - username
# %m - short hostname
# %~ - working directory
PS1="%n@%m:%~ "

# %M - full hostname
# %* - current HH:MM:SS
PS1="%n@%M [%*] %~ "

# %F{color} - sets color
# %f - resets color
PS1="%F{blue}%n@%m%f:%F{green}%~%f "
