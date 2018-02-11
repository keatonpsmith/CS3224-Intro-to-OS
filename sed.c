//Keaton Smith kps325
#include "types.h"
#include "stat.h"
#include "user.h"

char buf[1024];

void sed(char *look4, char *replace, int fd, char* name)
{
  int i, n;
  int count, found;

  count =  0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      found = 0;
      if (buf[i] == look4[1] ) {
        if(buf[i+1] == look4[2]) {
          if(buf[i+2] == look4[3]) {
            count++;
            found = 1;
            printf(1, "%c%c%c", replace[1], replace[2], replace[3]);
            i += 2;
          }
        }
      }
      if(!found) {
        printf(1, "%c", buf[i]);
      }
    }
  }
  if(n < 0){
    printf(1, "sed: read error\n");
    exit();
  }
  printf(1, "Found and replaced %d occurences.\n", count);
}

int main(int argc, char *argv[])
{
  int fd, i;
  if(argc <= 1){
    sed("-the", "-xyz", 0, "");
    exit();
  }
  else if(argc == 4){
    for(i = 3; i < argc; i++) {
      if((fd = open(argv[i], 0)) < 0){
        printf(1, "sed: cannot open %s\n", argv[i]);
        exit();
    }
    sed(argv[1], argv[2], fd, argv[i]);
    close(fd);
    }
  }
  if(argc == 2){
    for(i = 1; i < argc; i++) {
      if((fd = open(argv[i], 0)) < 0){
        printf(1, "sed: cannot open %s\n", argv[i]);
        exit();
      }
      sed("-the", "-xyz", fd, argv[i]);
      close(fd);
    }
  }
  exit();
}

