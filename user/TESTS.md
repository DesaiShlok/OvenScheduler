# Tests done for trace.bt

- Test1: Run trace.bt for a program that blocks for a certain time: 
        - Logic tested: If the blocking time is captured well for measuring run queue times and exec times. 
        - Expected Output: The time a task is blocked should not pop up on run queue times but the execution times should include the time a task was blocked.
- Test2: Trace multiple fibonnaci tasks on single CPU
        - Logic tested: With a single CPU run queue times for 2,3,4th consecutives tests should reflect the times it took for the previous execs to complete
        - Expected Output: If task 1 takes up 600ms to complete task 2/3/4(whichever one was executed just after 1) should have minimum 600ms of run queue times and execution time should be atleast runqueue time + its execution times
- Test3: Trace Multiple fibonnaci tasks on multiple CPUs (not sure if this test optimally tests a logic)
        - Logic Tested: If the behaviour with test2 is not followed in this test, as other CPUs are available to run the process too
        - Expected Output: The consecutive tasks should not be waiting on the previous tasks to finish of execution, atleast the tasks which have a free CPU to switch to