//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// filterAmp.h
//
// Code generation for function 'filterAmp'
//

#ifndef FILTERAMP_H
#define FILTERAMP_H

// Include files
#include "rtwtypes.h"
#include "coder_array.h"
#include <cstddef>
#include <cstdlib>

// Function Declarations
extern void filterAmp(const coder::array<double, 2U> &data, double minDB,
                      coder::array<double, 2U> &dataFil);

#endif
// End of code generation (filterAmp.h)
