//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// filterAmp.cpp
//
// Code generation for function 'filterAmp'
//

// Include files
#include "filterAmp.h"
#include "rt_nonfinite.h"
#include "std.h"
#include "coder_array.h"
#include <algorithm>
#include <cmath>

// Function Definitions
void filterAmp(const coder::array<double, 2U> &data, double minDB,
               coder::array<double, 2U> &dataFil)
{
  coder::array<double, 1U> b_dataFil;
  coder::array<short, 2U> r;
  double Window[300];
  double currentWindow[300];
  double secs_since_new_win;
  int i;
  int k;
  int nx;
  boolean_T x[300];
  // UNTITLED2 Summary of this function goes here
  //    Detailed explanation goes here
  dataFil.set_size(86400, data.size(1));
  nx = 86400 * data.size(1);
  for (i = 0; i < nx; i++) {
    dataFil[i] = data[i];
  }
  nx = 86400 * data.size(1);
  for (k = 0; k < nx; k++) {
    dataFil[k] = std::log10(dataFil[k]);
  }
  nx = 86400 * dataFil.size(1);
  dataFil.set_size(86400, dataFil.size(1));
  for (i = 0; i < nx; i++) {
    dataFil[i] = 20.0 * dataFil[i];
  }
  // n-sigma bound before tossing data
  for (nx = 0; nx < 300; nx++) {
    Window[nx] = rtNaN;
  }
  secs_since_new_win = 0.0;
  i = data.size(1);
  for (int dayind{0}; dayind < i; dayind++) {
    for (int thissec{0}; thissec < 86400; thissec++) {
      for (nx = 0; nx < 300; nx++) {
        currentWindow[nx] = rtNaN;
      }
      if (dataFil[thissec + 86400 * dayind] < minDB) {
        dataFil[thissec + 86400 * dayind] = rtNaN;
      } else {
        double d;
        double scale;
        double y;
        int nz;
        if (thissec + 1 > 300) {
          if (thissec - 299 > thissec) {
            nz = 0;
            k = 0;
          } else {
            nz = thissec - 300;
            k = thissec;
          }
          nx = k - nz;
          b_dataFil.set_size(nx);
          for (k = 0; k < nx; k++) {
            b_dataFil[k] = dataFil[(nz + k) + 86400 * dayind];
          }
          for (nz = 0; nz < 300; nz++) {
            currentWindow[nz] = b_dataFil[nz];
          }
        } else if (dayind + 1 > 1) {
          if (thissec + 1 > 2) {
            if (thissec + 86101 > 86400) {
              nz = 0;
            } else {
              nz = thissec + 86100;
            }
            if (1 > 300 - thissec) {
              k = 0;
            } else {
              k = 300 - thissec;
            }
            r.set_size(1, static_cast<int>(static_cast<short>(k)));
            nx = static_cast<short>(k) - 1;
            for (k = 0; k <= nx; k++) {
              r[k] = static_cast<short>(k);
            }
            nx = r.size(1);
            for (k = 0; k < nx; k++) {
              currentWindow[r[k]] = dataFil[(nz + k) + 86400 * (dayind - 1)];
            }
            if (301 - thissec > 300) {
              nz = 1;
              k = 0;
            } else {
              nz = 301 - thissec;
              k = 300;
            }
            nx = k - static_cast<short>(nz);
            r.set_size(1, nx + 1);
            for (k = 0; k <= nx; k++) {
              r[k] =
                  static_cast<short>(static_cast<short>(static_cast<short>(nz) +
                                                        static_cast<short>(k)) -
                                     1);
            }
            nx = r.size(1);
            for (nz = 0; nz < nx; nz++) {
              currentWindow[r[nz]] = dataFil[nz + 86400 * dayind];
            }
          } else if (thissec + 1 == 2) {
            for (nz = 0; nz < 299; nz++) {
              currentWindow[nz] = dataFil[(nz + 86400 * (dayind - 1)) + 86101];
            }
            currentWindow[299] = dataFil[86400 * dayind];
          } else {
            for (nz = 0; nz < 300; nz++) {
              currentWindow[nz] = dataFil[(nz + 86400 * (dayind - 1)) + 86100];
            }
          }
        } else {
          for (nz = 0; nz < 300; nz++) {
            currentWindow[nz] = dataFil[nz + 86400 * dayind];
          }
        }
        for (nx = 0; nx < 300; nx++) {
          x[nx] = std::isnan(currentWindow[nx]);
        }
        nz = x[0];
        for (k = 0; k < 299; k++) {
          nz += x[k + 1];
        }
        for (nx = 0; nx < 300; nx++) {
          x[nx] = std::isnan(Window[nx]);
        }
        nx = x[0];
        for (k = 0; k < 299; k++) {
          nx += x[k + 1];
        }
        if ((nz < 150) || (nx == 300)) {
          std::copy(&currentWindow[0], &currentWindow[300], &Window[0]);
          secs_since_new_win = 0.0;
          scale = 5.0 * coder::b_std(Window);
        } else {
          secs_since_new_win++;
          scale = secs_since_new_win / 300.0 + 1.0;
          if (scale > 4.0) {
            scale = 4.0;
          }
          scale = scale * 5.0 * coder::b_std(Window);
        }
        if (std::isnan(Window[0])) {
          y = 0.0;
          nx = 0;
        } else {
          y = Window[0];
          nx = 1;
        }
        for (k = 0; k < 299; k++) {
          d = Window[k + 1];
          if (!std::isnan(d)) {
            y += d;
            nx++;
          }
        }
        d = dataFil[thissec + 86400 * dayind];
        if ((d < y / static_cast<double>(nx) - scale) || (d < minDB)) {
          dataFil[thissec + 86400 * dayind] = rtNaN;
        }
      }
    }
  }
}

// End of code generation (filterAmp.cpp)
