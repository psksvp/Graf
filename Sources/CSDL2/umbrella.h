#ifdef __APPLE__
#ifdef __IPHONEOS__
  #include "ios.h"
#else
	#include "macOS.h"
#endif
#else
	#include "linux.h"
#endif
