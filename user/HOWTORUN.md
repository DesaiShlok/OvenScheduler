# How to trace a custom process with the same MonitorRunbpftrace.sh for fibonacci processess

MonitorRunbpftrace file will internally run the trace.bt script. FILTER_COMM field in MonitorRunbpftrace.sh is the Comm field of the process you want to monitor. The MonitorRunbpftrace.sh will also save the outputs in the OUTPUT_FILE specified.

To monitor a custom file other than fibonacci change the runbpftrace.sh file with the info of your compiled c program

Then run commands "chmod +x MonitorRunbpftrace.sh" and "chmod +x runbpftrace.sh" to compile the shell scripts

To trace the process run ./MonitorRunbpftrace in one terminal and then run the ./runbpftrace.sh shell script with your job files

