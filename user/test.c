#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#define NUM_LOOPS 10
#define SLEEP_DURATION_US 1000000
unsigned long long fib(unsigned long long n)
{
	if (n <= 1)
		return n;
	else
		return fib(n - 1) + fib(n - 2);
}

int main(void)
{
	struct sched_param params = {0};
	pid_t forkedPid = getpid();
	int b = 0;
	/** Can be commented out as well doesnt really matter -Giorgio */
	int ret = sched_setscheduler(forkedPid, SCHED_OTHER, &params);
	for (int i = 0; i < NUM_LOOPS; ++i) {
		// sleep(1);
		long unsigned result = fib(40);
	}

	printf("----------------------------------------\n");
	printf("--- Test Program Finished ---\n");
	return 0;
}
