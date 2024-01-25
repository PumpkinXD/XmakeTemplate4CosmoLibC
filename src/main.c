#include "example.h"

int main(){
  struct utsname names;
  if (uname(&names)) return 1;
  printf("your OS is %`'s\n",names.sysname);
  say_hi();
  return 0;
}
