#include "types.h"
#include "stat.h"
#include "user.h"

#define NUM_CHILDREN 10
#define ITERATIONS 100

int main() 
{ 
    for (int r = 0; r < NUM_CHILDREN; r++) 
    {
        int pid = fork();

        if (pid < 0) 
        {
            // Handle fork failure
            printf(1, "Fork failed for child %d\n", r);
            exit();
        } 
        else if (pid == 0) 
        {
            volatile int sum = 0; // Prevent compiler optimization
            for (int i = 0; i < ITERATIONS; i++) {
                for (int j = 0; j < ITERATIONS / 10; j++) {
                    sum += (i * j) % (r + 1);  // Nested operation
                }
            }
            exit(); 
        }

        SJF_init(pid, pid*2, r*r%100);
    }

    for (int i = 0; i < NUM_CHILDREN; i++) {
        if (wait() < 0) 
        {
            printf(1, "Wait failed for child %d\n", i);
            exit();
        }
    }
    exit();
}
