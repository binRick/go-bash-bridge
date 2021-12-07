#include <pthread.h>
#include <stdio.h>
#include "chan/chan.h"


chan_t* chan0;

void* bping(){
    chan_send(chan0, "bping");
    return NULL;
}

int do_bchan(){
    int64_t s = timestamp();
    chan_t *chan = chan_init(2);


    void* msg0;
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

    int64_t e = timestamp();
    int64_t dur = e - s;
    info("Buffered Channels Completed in %dms", dur);
}
