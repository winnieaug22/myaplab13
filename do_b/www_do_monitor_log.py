#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# --- usage ---
# aplab13: python www_do_monitor_log.py
# aplab14: python3 www_do_monitor_log.py
import time
import os
import io
from datetime import datetime

# --- Configuration ---
LOG_FILE = "verilog.log"
SEARCH_TERM = "www_debug"
CHECK_INTERVAL_SECONDS = 300  # 5 minutes
# --- End of Configuration ---

def find_all_matches_in_file(filepath, term):
    """Counts the number of lines containing the term and returns a list of all matches."""
    # Check if the file exists
    if not os.path.exists(filepath):
        return 0, []
    
    matches = []
    try:
        # Open the file, ignoring potential encoding errors
        with io.open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            for line in f:
                if term in line:
                    matches.append(line.strip())
        return len(matches), matches
    except IOError as e:
        # Handle file read errors
        print("[{0}] ERROR: Could not read file {1}: {2}".format(datetime.now().strftime('%Y-%m-%d %H:%M:%S'), filepath, e))
        return -1, [] # Return an error code

def main():
    """Main monitoring loop."""
    print("--- Starting to monitor file '{0}' for keyword '{1}' ---".format(LOG_FILE, SEARCH_TERM))
    print("Check interval: {0} seconds".format(CHECK_INTERVAL_SECONDS))
    print("------------------------------------------------")

    try:
        # Get the initial line count
        current_count, _ = find_all_matches_in_file(LOG_FILE, SEARCH_TERM)
        if current_count == -1:
            print("Exiting due to initial file read failure.")
            return

        print("[{0}] Initial count for '{1}': {2}".format(datetime.now().strftime('%Y-%m-%d %H:%M:%S'), SEARCH_TERM, current_count))

        while True:
            time.sleep(CHECK_INTERVAL_SECONDS)

            new_count, all_matches = find_all_matches_in_file(LOG_FILE, SEARCH_TERM)
            if new_count == -1:
                continue # If reading fails, skip this check and try again later

            if new_count > current_count:
                added_lines = new_count - current_count
                print("[{0}] New entries for '{1}' detected! ({2} new lines)".format(datetime.now().strftime('%Y-%m-%d %H:%M:%S'), SEARCH_TERM, added_lines))
                new_matches = all_matches[-added_lines:]
                for match in new_matches:
                    print("    - {0}".format(match))
                current_count = new_count
            elif new_count < current_count:
                # Handle cases where the log file was cleared or rotated
                print("[{0}] Log line count decreased, file may have been reset. Resetting counter.".format(datetime.now().strftime('%Y-%m-%d %H:%M:%S')))
                current_count = new_count
            else:
                # No new entries found
                print("[{0}] No new entries detected. Current total: {1}".format(datetime.now().strftime('%Y-%m-%d %H:%M:%S'), current_count))

    except KeyboardInterrupt:
        print("\nMonitoring stopped by user.")

if __name__ == "__main__":
    main()
