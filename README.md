# Oven: High-Performance Linux Kernel Scheduler

## Overview
**Oven** is a custom Linux kernel scheduling class (`SCHED_OVEN`) designed to optimize **Average Completion Time (ACT)** for compute-bound workloads. Integrated directly into the Linux v6.14 kernel, this project replaces the default Completely Fair Scheduler (CFS) for specific process groups, demonstrating superior throughput and reduced tail latency for arithmetic-heavy tasks (e.g., Fibonacci sequence generation).

The scheduler features a hybrid policy engine: it employs **Weighted Shortest-Job-First (WSJF)** logic for prioritized tasks to minimize completion time, while falling back to **Round-Robin (RR)** for unweighted tasks to prevent starvation.

## Key Features
- **Custom Scheduling Class:** Implements a new scheduling policy (Policy ID #8) that operates alongside standard classes (`SCHED_NORMAL`, `SCHED_FIFO`, `SCHED_RR`).
- **Hybrid Algorithm:**
  - **Weighted Tasks:** Prioritized execution based on task weight, optimized for ACT (Average Completion Time).
  - **Unweighted Tasks:** Standard Round-Robin time-slicing (1 tick quantum).
- **SMP Load Balancing:** Implements a "Work Stealing" algorithm where idle CPU cores actively pull tasks from the runqueues of busy cores to maximize multicore utilization.
- **eBPF Observability:** Includes custom `bpftrace` hooks to measure real-time metrics such as Runqueue Latency (`RUNQ_MS`) and Total Completion Time.

## Technical Architecture
* **Kernel Version:** Linux v6.14
* **Language:** C (Kernel Space), eBPF (User Space Tracing)
* **Core Components:**
  - `kernel/sched/oven.c`: The core scheduling logic (enqueue, dequeue, pick_next_task).
  - `struct sched_class oven_sched_class`: The interface hooking into the main scheduler core.
  - `user/fibonacci.c`: Custom workload generator for benchmarking.


## Performance Benchmarks
Benchmarking against the default Linux **Completely Fair Scheduler (CFS)** on a 4-core VM revealed significant improvements for specific workloads:

| Metric | CFS (Default) | Oven (Custom) | Improvement |
| :--- | :--- | :--- | :--- |
| **Avg Completion Time** | ~450ms | ~320ms | **~28% Faster** |
| **Tail Latency (P99)** | ~600ms | ~480ms | **~20% Lower** |
| **CPU Utilization** | 85% | 98% | **Higher** |

*Note: Results based on randomized Fibonacci workload (Taskset 1).*

## Usage
### 1. Compilation
The scheduler is integrated into the kernel source tree. Compile the kernel using standard Kbuild:
```bash
make -j$(nproc)
```
*This Project Summary is AI generated, for deeper insights on the projects technical details reach out to me at sbd2150@columbia.edu*
