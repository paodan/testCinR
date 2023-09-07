#include <stdio.h>



/* this function is to test the relationship between pointer, pointer of pointer, array, and value
 *
 */
void testPointerAddress(double *data)
{
  //int len = sizeof(data)/sizeof(double*);
  printf("'data' is a pointer to an array and also the pointer to the first element of the array -- data: %p\n", (void*)data);

  printf("'&data' is a pointer to a pointer ('data') -- &data: %p\n", (void*)&data);
  for (int i = 0; i < 3; i++){
    // data is a pointer, &data is the address of data, &data[0] is the address of data[0]
    printf("'data[i]' is a value -- data[%d]: %f,\t '&data[i]' is a pointer to data[i] -- &data[%d]: %p\n", i, data[i], i, (void*)&data[i]);
  }

  for(int i = 0; i < 3; i++){
    printf("'*data' is one value of the pointer ('data') points to -- *data: %f, data: %p\ndata++\n", *data, (void*)data);
    data++;
  }

  for (int i = 0; i < 3; i++){
    // data is a pointer, &data is the address of data, &data[0] is the address of data[0]
    printf("'data[i]' is a value -- data[%d]: %f,\t '&data[i]' is a pointer to data[i] -- &data[%d]: %p\n", i, data[i], i, (void*)&data[i]);
  }

  return;
}
