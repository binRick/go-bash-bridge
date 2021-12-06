#ifndef __GBB_LOAD_H
#define __GBB_LOAD_H

#define __gbbloaderAppend( _v , _n ) _v ## _n
#define  _gbbloaderAppend( _v , _n ) __gbbloaderAppend( _v , _n )
#define   gbbloaderVectorReference     _gbbloaderAppend( OBJ_NAME , _gbbloaderVectorReference     )
#define   gbbloaderFunc     _gbbloaderAppend( OBJ_NAME , _gbbloaderFunc     )
#define   gbbloaderLoadFunc _gbbloaderAppend( OBJ_NAME , _gbbloaderLoadFunc )


#define __LOADER( _v )                          \
        void gbbloaderFunc() ;                         \
        struct gbbLoaderFunc_vector gbbloaderVectorReference ;           \
        __attribute__ ((__constructor__))       \
        void gbbloaderLoadFunc(void){                  \
             gbbloaderVectorReference.name = #_v ;                \
             gbbloaderVectorReference.file = __FILE__ ;           \
             gbbloaderVectorReference.f = gbbloaderFunc ;                \
             gbbloaderVectorReference.next = vect ;               \
             vect = &gbbloaderVectorReference ;                   \
             printf(#_v "> PRE-HOOK\n");     \
        }
#define  _LOADER( _v )  __LOADER( _v )
#define   LOADER         _LOADER(OBJ_NAME)

struct gbbLoaderFunc_vector{
        char * name;
        char * file;
        void (*f)();
        struct gbbLoaderFunc_vector * next;
};

extern struct gbbLoaderFunc_vector * vect;

#endif
