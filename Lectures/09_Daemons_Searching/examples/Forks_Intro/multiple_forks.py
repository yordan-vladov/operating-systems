# Importing os module
import os

# Creating child processes using fork() method
os.fork()
os.fork()

# This will be executed by both parent & child processes
print("Hello from a process.")
