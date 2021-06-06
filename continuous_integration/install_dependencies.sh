#!/bin/bash
# This script is meant to be called by the "install" step defined in
# build.yml. The behavior of the script is controlled by environment 
# variables defined in the build.yml in .github/workflows/.

set -e

if [[ "$PYTHON_VERSION" == "3.6" ]]; then
  conda install scipy=1.3 numpy=1.16 mkl pip pytest lapack ecos scs osqp flake8 cvxopt coincbc
  python -m pip install cplex
elif [[ "$PYTHON_VERSION" == "3.7" ]]; then
  conda install scipy=1.3 numpy=1.16 mkl pip pytest lapack ecos scs osqp flake8 cvxopt
  python -m pip install cplex
elif [[ "$PYTHON_VERSION" == "3.8" ]]; then
  # There is a config that works with numpy 1.14, but not 1.15!
  # So we fix things at 1.16.
  # Assuming we use numpy 1.16, the earliest version of scipy we can use is 1.3.
  conda install scipy=1.3 numpy=1.16 mkl pip pytest lapack ecos scs osqp flake8 cvxopt
  python -m pip install cplex
elif [[ "$PYTHON_VERSION" == "3.9" ]]; then
  # The earliest version of numpy that works is 1.19.
  # Given numpy 1.19, the earliest version of scipy we can use is 1.5.
  conda install scipy=1.5 numpy=1.19 mkl pip pytest lapack ecos scs osqp flake8 cvxopt
fi

if [[ "$RUNNER_OS" != "windows"* ]]; then
    conda install coincbc
fi

python -m pip install diffcp gurobipy xpress cylp

if [[ "$USE_OPENMP" == "True" ]]; then
    conda install -c conda-forge openmp
fi

if [[ "$COVERAGE" == "True" ]]; then
    python -m pip install coverage coveralls
fi
