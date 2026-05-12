import os


print("Starting the program...")

# Fork the current process
pid = os.fork() # Връща число
# -1<= => Fork е неуспешен
if pid <= -1:
    print("Forks is unsuccesfull.")
    exit(1)
# 0 => Child процес
# >=1 => Parent процес

if pid == 0:
    # This block runs in the child process
    print("Child process:")
    print(f"  PID: {os.getpid()}")  # Process ID of the child
    print(f"  Parent PID: {os.getppid()}")  # Parent's Process ID
else:
    # This block runs in the parent process
    print("Parent process:")
    print(f"  PID: {os.getpid()}")  # Process ID of the parent
    print(f"  Child PID: {pid}")  # Process ID of the created child

# Both processes execute this
print(f"Process {os.getpid()} says hello!")
