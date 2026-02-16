import logging
import random
import time

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[
        logging.FileHandler("server.log"),  # Log to a file
        logging.StreamHandler()  # Log to the console
    ]
)

# List of random messages to log
messages = [
    "Server started successfully.",
    "Processing request from client 192.168.1.10.",
    "Database connection established.",
    "Error: Unable to connect to the database.",
    "Sending response to client 192.168.1.15.",
    "Server shutdown initiated.",
    "Backup completed successfully.",
    "Warning: High CPU usage detected.",
    "New user registered: john_doe.",
    "File upload completed: report.pdf."
]

def simulate_server():
    """Simulate a server by logging random messages at random intervals."""
    logging.info("Server simulation started.")

    try:
        while True:
            # Log a random message
            message = random.choice(messages)
            logging.info(message)

            # Wait for a random interval between 1 and 10 seconds
            delay = random.randint(1, 10)
            time.sleep(delay)
    except KeyboardInterrupt:
        logging.info("Server simulation stopped.")

if __name__ == "__main__":
    simulate_server()
