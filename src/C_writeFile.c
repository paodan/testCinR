#include <stdio.h>
#include <stdlib.h>

/*
 fileName: pointer to the name of the file to be written.
 num: pointer to the double array to be saved in the fileName.
 length: the length of the array num.

 Example:


 int main(int argc, char **argv)
 {
 // Using char **c
 char *strings[] = {argv[1]};
 char **fileName = strings;
 //double *num;
 int length = argc - 2; // Calculate the length of the array
 double *num = (double *)malloc(length * sizeof(double)); // Allocate memory

 for(int i = 2; i < argc; i++) {
    num[i - 2] = atof(argv[i]);
 }
 C_writeFile(fileName, num, &length);

 // Free the allocated memory
 free(num);
 return 0;
 }

 */
void C_writeFile(char **fileName, double *num, int *len)
{
  int length = *len;
  FILE *fptr;
  // use appropriate location if you are using MacOS or Linux
  fptr = fopen(*fileName,"w");

  if(fptr == NULL)
  {
    printf("Error!");
    exit(1);
  }

  // save each number in each row
  for(int i = 0; i < length; i++){
    fprintf(fptr,"%f\n", num[i]);
  }
  fclose(fptr);
}
