#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

static void child_work(void) {
    volatile int child_value = 42; // Put a breakpoint here.
    printf("child pid=%ld value=%d\n", (long)getpid(), child_value);
    fflush(stdout);
}

static void parent_work(pid_t child_pid) {
    volatile int parent_value = 7; // Put a breakpoint here.
    printf("parent pid=%ld child=%ld value=%d\n",
           (long)getpid(), (long)child_pid, parent_value);
    fflush(stdout);
}

int main(void) {
    pid_t pid = fork();
    if (pid < 0) {
        perror("fork");
        return EXIT_FAILURE;
    }
    if (pid == 0) {
        child_work();
        execl("/bin/echo", "echo", "child exec completed", (char *)NULL);
        perror("execl");
        _exit(127);
    }
    parent_work(pid);
    int status = 0;
    if (waitpid(pid, &status, 0) < 0) {
        perror("waitpid");
        return EXIT_FAILURE;
    }
    return WIFEXITED(status) ? WEXITSTATUS(status) : EXIT_FAILURE;
}
