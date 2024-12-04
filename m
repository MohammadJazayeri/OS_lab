[1mdiff --git a/proc.c b/proc.c[m
[1mindex b7c0ce3..882620e 100644[m
[1m--- a/proc.c[m
[1m+++ b/proc.c[m
[36m@@ -459,7 +459,6 @@[m [mscheduler(void)[m
       if((p->state != RUNNABLE) || (p->level_queue != 0))[m
         continue;[m
       int min_last_exec = find_min_last_exec();[m
[31m-      // cprintf("pid %d cur %d vc. min %d\n", p->pid, p->last_exec, min_last_exec);[m
       if(p->last_exec == min_last_exec)[m
       {[m
         // Switch to chosen process.  It is the process's job[m
[36m@@ -482,19 +481,19 @@[m [mscheduler(void)[m
     // SJF[m
     for(int j = 0; j < NPROC; j++){[m
       int count = sort_pcbs_by_burst();[m
[31m-      int seed = (ticks * 17) % 100;[m
[32m+[m[32m      int seed = (ticks * 19) % 100;[m
       if(count > 0){[m
[31m-        cprintf("count is: %d and seed is %d\n", count, seed);[m
[32m+[m[32m        // cprintf("count is: %d and seed is %d\n", count, seed);[m
         struct proc *p = sorted_procs[count - 1];[m
         for (int i = 0; i < count; i++) {[m
[31m-          cprintf("%d. certainty: %d\n", sorted_procs[i]->pid, sorted_procs[i]->certainty);[m
[32m+[m[32m          // cprintf("%d. certainty: %d\n", sorted_procs[i]->pid, sorted_procs[i]->certainty);[m
             if (sorted_procs[i]->certainty > seed) {[m
                 p = sorted_procs[i];[m
                 // Run the process with the shortest burst time[m
                 break;[m
             }[m
         }[m
[31m-        cprintf("shortest is: %d with burst: %d and certainty: %d\n", p->pid, p->burst, p->certainty);[m
[32m+[m[32m        // cprintf("shortest is: %d with burst: %d and certainty: %d\n", p->pid, p->burst, p->certainty);[m
         c->proc = p;[m
         switchuvm(p);[m
         p->state = RUNNING;[m
