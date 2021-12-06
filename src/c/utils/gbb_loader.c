#include <stdio.h>
#include "../utils/gbb_load.h"
struct gbbLoaderFunc_vector * vect = 0;
void gbbLoaderParse_all(){
        struct gbbLoaderFunc_vector * v = vect;
        printf("\ngbbLoaderParse_all:\n");
        while(v){
               printf("Found ----> %s\n",v->name); 
               printf("in file --> %s\n",v->file); 
               printf("Exec it:----------------------------------------\n");
               v->f();
               printf("------------------------------------------------\n");
               printf("\n");
               v = v->next;
        }
}
