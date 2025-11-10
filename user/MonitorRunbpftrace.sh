#!/usr/bin/env bash

# This script runs 'sudo bpftrace trace.bt' and filters its output.
#
# 1. It finds the 'trace.bt' file in the same directory as this script.
# 2. It runs 'sudo bpftrace' with that file.
# 3. It pipes the output to 'awk' for filtering.
# 4. It uses 'tee' to save the filtered output to "fibonacci_trace.txt"
#    AND simultaneously print it to your terminal.
#
# The script will run continuously until you press Ctrl+C.

# --- Configuration ---
# The bpftrace program to run
BPF_PROGRAM="trace.bt"
# The file where filtered output will be saved
OUTPUT_FILE="fibonacci_trace.txt"
# The COMM name to filter for
FILTER_COMM="fibonacci"
# --- End Configuration ---

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
BPF_FILE_PATH="$SCRIPT_DIR/$BPF_PROGRAM"

# Check if the trace.bt file exists
if [ ! -f "$BPF_FILE_PATH" ]; then
    echo "Error: $BPF_PROGRAM not found in script directory:"
    echo "$SCRIPT_DIR"
    exit 1
fi

# Removed the "Attaching probes..." line as requested.
# bpftrace will print its own "Attaching probes..." message.
echo "Filtering for COMM '$FILTER_COMM' and saving to $OUTPUT_FILE"
echo "Press Ctrl+C to stop."

# Run the command and filter the output
#
# - sudo bpftrace $BPF_FILE_PATH:
#   Runs your trace program with root privileges.
#
# - stdbuf -oL awk ...:
#   'stdbuf -oL' forces 'awk' to be "line-buffered". This prevents 'awk'
#   from waiting for a large chunk of data before printing, ensuring you
#   see output in real-time as it's generated.
#
# - awk -F, 'NR==1 {print} $1=="'"$FILTER_COMM"'" {print}':
#   This is the filtering logic.
#   -F,             : Sets the "Field" separator to a comma.
#   NR==1 {print}   : "NR" means "Number of Record (line)".
#                     If it's the first line (NR==1), print it (this gets the header).
#   $1=="fibonacci" {print}:
#                     For all other lines, check if the first field ($1)
#                     is exactly equal to the value of $FILTER_COMM.
#                     If it is, print that line.
#
# - tee $OUTPUT_FILE:
# ... existing code ... -->
# - awk -F, '$1 == "COMM" || $1 == "'"$FILTER_COMM"'" {print}':
#   This is the filtering logic.
#   -F,             : Sets the "Field" separator to a comma.
#   $1 == "COMM"    : Prints the line if the first field is "COMM" (this
#                     gets the header).
#   ||              : OR
#   $1 == "'"$FILTER_COMM"'" : Prints the line if the first field is
#                     the value of $FILTER_COMM (e.g., "fibonacci").
#
# - tee $OUTPUT_FILE:
#   Takes the output from 'awk' and sends it to two places:
#   1. To the $OUTPUT_FILE (fibonacci_trace.txt)
#   2. To stdout (your terminal screen)
#
sudo bpftrace "$BPF_FILE_PATH" | stdbuf -oL awk -F, '$1 == "COMM" || $1 == "'"$FILTER_COMM"'" {print}' | tee "$OUTPUT_FILE"

echo -e "\nTrace stopped. Filtered output saved to $OUTPUT_FILE."

