## disable ALSR

sudo sysctl -w kernel.randomize_va_space=0

## enable ALSR

sudo sysctl -w kernel.randomize_va_space=2
