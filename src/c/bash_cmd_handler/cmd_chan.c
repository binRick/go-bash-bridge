#include <errno.h>
#include <limits.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sysexits.h>
#define DEBUG_MODE 0

chan_t *chan0;
chan_t *jobs0;
chan_t *done0;

void * worker()
{
    // Process jobs until channel is closed.
    void *job;

    while (chan_recv(jobs0, &job) == 0)
    {
        printf("received job %d\n", (int)job);
    }

    // Notify that all jobs were received.
    printf("received all jobs\n");
    chan_send(done0, "1");
    return NULL;
}


int main_worker()
{
    jobs0 = chan_init(5);
    done0 = chan_init(0);

    pthread_t th;

    pthread_create(&th, NULL, worker, NULL);

    int i;

    for (i = 1; i <= 3; i++)
    {
        chan_send(jobs0, (void *)(uintptr_t)i);
        if(DEBUG_MODE == 1)
          printf("sent job %d\n", i);
    }
    chan_close(jobs0);
    printf("sent all jobs\n");

    // Wait for all jobs to be received.
    chan_recv(done0, NULL);

    // Clean up channels.
    chan_dispose(jobs0);
    chan_dispose(done0);
}


void * bping()
{
    chan_send(chan0, "bping");
    return NULL;
}


int do_bchan()
{
    main_worker();
    return 0;

    int64_t s     = timestamp();
    chan_t  *chan = chan_init(2);


    void      *msg0;
    pthread_t th;

    chan0 = chan_init(5);

    pthread_create(&th, NULL, bping, NULL);
    chan_recv(chan0, &msg0);
    char *info0[strlen(msg0) + 100];

    sprintf(info0, "[CHAN0] %d Byte Msg Recvd via channel> %s", strlen(msg0), msg0);
    info(info0);
    chan_dispose(chan0);



    chan_send(chan, "buffered");
    chan_send(chan, "channel");

    void *msg;

    chan_recv(chan, &msg);
    char *info[strlen(msg) + 100];

    sprintf(info, "%d Byte Msg Recvd via channel> %s", strlen(msg), msg);
    info(info);

    chan_recv(chan, &msg);
    char *info1[strlen(msg) + 100];

    sprintf(info1, "%d Byte Msg Recvd via channel> %s", strlen(msg), msg);
    info(info1);


    chan_dispose(chan);

    int64_t e   = timestamp();
    int64_t dur = e - s;

    info("Buffered Channels Completed in %dms", dur);
}
