#ifdef __APPLE__
#ifdef __IPHONEOS__
  #include "/usr/local/include/cairo/cairo.h"
#else
	#include "/usr/local/include/cairo/cairo.h"
#endif
#else
	#include "/usr/include/cairo/cairo.h"
#endif
