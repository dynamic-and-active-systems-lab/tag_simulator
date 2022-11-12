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
#include "tag_simulator_terminate.h"
#include "DAHostLib_Network.h"
#include "DAHostLib_rtw.h"
#include <stdio.h>

/* Function Declarations */
static void argInit_1x2_real_T(double result[2]);

static double argInit_real_T(void);

static unsigned int argInit_uint32_T(void);

/* Function Definitions */
static void argInit_1x2_real_T(double result[2])
{
  int idx1;
  /* Loop over the array to initialize each element. */
  for (idx1 = 0; idx1 < 2; idx1++) {
    /* Set the value of the array element.
Change this value to the value that the application requires. */
    result[idx1] = argInit_real_T();
  }
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
    unsigned long int sampleRate;
    double basebandFreq[2] ;
    double tip[2];
    double SNRdB[2];
    
    sampleRate = strtof(argv[1],NULL);
    /* basebandFreq[0] = strtof(argv[2],NULL);
     basebandFreq[1] = strtof(argv[3],NULL); */
    int i;
    int counter = 0;
    
    printf("Initialization done\n");
    for(i = 2; i < argc - 2; i = i + 3  ){
        printf("i: %u \n",i);
        printf("argc: %u \n",argc);
        basebandFreq[counter] = strtof(argv[i],NULL);
        printf("Momo: %u \n",counter);
        tip[counter]          = strtof(argv[i+1],NULL);
        SNRdB[counter]        = strtof(argv[i+2],NULL);
        counter++;
        printf("Counter: %u \n",counter);
    }

  /* The initialize function is being called automatically from your entry-point
   * function. So, a call to initialize is not included here. */
  /* Invoke the entry-point functions.
You can call entry-point functions multiple times. */
  main_tag_simulator(sampleRate, basebandFreq, tip, SNRdB);
  /* Terminate the application.
You do not need to do this more than one time. */
  tag_simulator_terminate();
  return 0;
}

void main_tag_simulator( unsigned long int sampleRate, double basebandFreq[2], double tip[2], double SNRdB[2])
{
  /* double dv[2]; */
  /* Initialize function 'tag_simulator' input arguments. */
  /* Initialize function input argument 'basebandFreq'. */
  /* Call the entry-point 'tag_simulator'. */
  /*argInit_1x2_real_T(dv);*/
  /* tag_simulator(argInit_uint32_T(), dv); */
    int i;
    for(i = 0; i < 2; i++ ){
        printf("basebandFreq: %f \n", basebandFreq[i]);
        printf("tip: %f \n",          tip[i]);
        printf("SNRdB: %f \n",        SNRdB[i]);

    }

    
    
    tag_simulator(sampleRate, &basebandFreq, &tip, &SNRdB);
}

/* End of code generation (main.c) */
