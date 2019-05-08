#include <stdlib.h>
#include <stdio.h>

int main(int argc, char* argv[]){
  char strin[80];
  int i;
  sprintf(strin, "./canviagrup.sh");
  for (i=1;i<argc;i++){
    sprintf(strin, "%s %s", strin, argv[i]);
  }
  system(strin);
}
