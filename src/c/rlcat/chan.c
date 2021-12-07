#include <pthread.h>
#include <stdio.h>
#include "chan/chan.h"

chan_t *chan;

void * ping()
{
    // Send blocks until receiver is ready.
    chan_send(chan, "ping");
    return NULL;
}


int do_chan()
{
    // Initialize unbuffered channel.
    chan = chan_init(0);

    pthread_t th;

    pthread_create(&th, NULL, ping, NULL);

    // Receive blocks until sender is ready.
    void *msg;

    chan_recv(chan, &msg);
    printf("%s\n", msg);

    // Clean up channel.
    chan_dispose(chan);

    term_reset();
    printf("reset\n");

    term_color("green");
    printf("\nCHANS OK!\n");
}
