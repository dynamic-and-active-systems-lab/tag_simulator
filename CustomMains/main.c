/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * main.c
 *
 * Code generation for function 'main'
 *
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/

/* Include files */
#include "main.h"
#include "rt_nonfinite.h"
#include "tag_simulator.h"
#include "tag_simulator_emxAPI.h"
#include "tag_simulator_terminate.h"
#include "tag_simulator_types.h"
#include "DAHostLib_Network.h"
#include "DAHostLib_rtw.h"
#include <stdio.h>

/* Function Declarations */
static emxArray_real_T *argInit_1xUnbounded_real_T(int elements);

static double argInit_real_T(void);

static unsigned int argInit_uint32_T(void);

/* Function Definitions */
static emxArray_real_T *argInit_1xUnbounded_real_T( int elements)
{
  emxArray_real_T *result;
  double *result_data;
  int idx0;
  int idx1;
  /* Set the size of the array.
Change this size to the value that the application requires. */
    /* result = emxCreate_real_T(1, 2); */
  result = emxCreate_real_T(1, elements);
  result_data = result->data;
  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 1; idx0++) {
    for (idx1 = 0; idx1 < result->size[1U]; idx1++) {
      /* Set the value of the array element.
Change this value to the value that the application requires. */
      result_data[idx1] = argInit_real_T();
    }
  }
  return result;
}

static double argInit_real_T(void)
{
  return 0.0;
}

static unsigned int argInit_uint32_T(void)
{
  return 0U;
}

int main(int argc, char **argv)
{
  (void)argc;
  (void)argv;
    
   /* ******** CUSTOM CHANGES TO EXAMPLE MAIN ********** */
    
    unsigned long int sampleRate;
    double basebandFreq[20] ;
    double tip[20];
    double SNRdB[20];
    
    sampleRate = strtof(argv[1],NULL);
    /* basebandFreq[0] = strtof(argv[2],NULL);
     basebandFreq[1] = strtof(argv[3],NULL); */
    int i;
    int counter = 0;
    int elements = 0;
    
    printf("Initialization done\n");
    for(i = 2; i < argc - 2; i = i + 3  ){
        printf("i: %u \n",i);
        printf("argc: %u \n",argc);
        basebandFreq[counter] = strtof(argv[i],NULL);
        tip[counter]          = strtof(argv[i+1],NULL);
        SNRdB[counter]        = strtof(argv[i+2],NULL);
        counter++;
    }
    elements = counter;
    /* ******** CUSTOM CHANGES TO EXAMPLE MAIN ********** */
    
    
    
  /* The initialize function is being called automatically from your entry-point
   * function. So, a call to initialize is not included here. */
  /* Invoke the entry-point functions.
You can call entry-point functions multiple times. */
  main_tag_simulator(sampleRate, basebandFreq, tip, SNRdB, elements);
    
  /* Terminate the application.
You do not need to do this more than one time. */
  tag_simulator_terminate();
  return 0;
}

void main_tag_simulator( unsigned long int sampleRate, double *basebandFreqArray, double *tipArray, double *SNRdBArray, int elements)
{
    
    /* ******** CUSTOM CHANGES TO EXAMPLE MAIN **********
    int elements;
    elements = (int)( sizeof(basebandFreqArrayTest) / sizeof(basebandFreqArrayTest[0]));
    printf("Elements: %u \n",elements);

     ******** CUSTOM CHANGES TO EXAMPLE MAIN ********** */
    printf("Elements: %u \n",elements);
    
    
    emxArray_real_T *SNRdB;
    emxArray_real_T *basebandFreq;
    emxArray_real_T *tip;
    
    double *basebandFreq_data;
    double *tip_data;
    double *SNRdB_data;
    
    int i;
    
    /* Initialize function 'tag_simulator' input arguments. */
    /* Initialize function input argument 'basebandFreq'. */
    basebandFreq = argInit_1xUnbounded_real_T( elements );
    /* Initialize function input argument 'tip'. */
    tip = argInit_1xUnbounded_real_T( elements );
    /* Initialize function input argument 'SNRdB'. */
    SNRdB = argInit_1xUnbounded_real_T( elements );
    /* Call the entry-point 'tag_simulator'. */
           
                     
    /* ******** CUSTOM CHANGES TO EXAMPLE MAIN ********** */
                     
    basebandFreq_data = basebandFreq->data;
    tip_data = tip->data;
    SNRdB_data = SNRdB->data;

    printf("Entering emxArray_real_T data\n");
    for(i = 0; i < elements; i++ ){
        basebandFreq_data[i] = basebandFreqArray[i];
        tip_data[i]          = tipArray[i];
        SNRdB_data[i]        = SNRdBArray[i];
        
        printf("basebandFreq_data: %f \n",basebandFreq_data[i]);
        printf("tip_data: %f \n",tip_data[i]);
        printf("SNRdB_data: %f \n",SNRdB_data[i]);
        
        printf("Index: %u \n",i);
    }
                     
     /* ******** CUSTOM CHANGES TO EXAMPLE MAIN ********** */
                     
  tag_simulator(sampleRate, basebandFreq, tip, SNRdB);
  emxDestroyArray_real_T(SNRdB);
  emxDestroyArray_real_T(tip);
  emxDestroyArray_real_T(basebandFreq);
}

/* End of code generation (main.c) */
