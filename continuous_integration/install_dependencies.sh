#!/bin/bash
# This script is meant to be called by the "install" step defined in
# build.yml. The behavior of the script is controlled by environment 
# variables defined in the build.yml in .github/workflows/.

set -e

if [[ "$RUNNER_OS" == "Linux" ]]; then
    sudo apt-get update -qq
    sudo apt-get install -qq gfortran libgfortran3
fi


if [[ "$PYTHON_VERSION" == "3.6" ]]; then
  conda install scipy=1.1 numpy=1.15 mkl pip pytest lapack ecos scs osqp flake8 cvxopt
elif [[ "$PYTHON_VERSION" == "3.7" ]]; then
  conda install scipy=1.1 numpy=1.15 mkl pip pytest lapack ecos scs osqp flake8 cvxopt
elif [[ "$PYTHON_VERSION" == "3.8" ]]; then
  # There is a config that works with numpy 1.14, but not 1.15!
  # So we fix things at 1.16.
  # Assuming we use numpy 1.16, the earliest version of scipy we can use is 1.3.
  conda install scipy=1.3 numpy=1.16 mkl pip pytest lapack ecos scs osqp flake8 cvxopt
elif [[ "$PYTHON_VERSION" == "3.9" ]]; then
  # The earliest version of numpy that works is 1.19.
  # Given numpy 1.19, the earliest version of scipy we can use is 1.5.
  conda install scipy=1.5 numpy=1.19 mkl pip pytest lapack ecos scs osqp flake8 cvxopt
fi

if [[ "$USE_OPENMP" == "True" ]]; then
    conda install -c conda-forge openmp
fi

python -m pip install diffcp

if [[ "$COVERAGE" == "True" ]]; then
    python -m pip install coverage coveralls
fi

python --version
python -c "import numpy; print('numpy %s' % numpy.__version__)"
python -c "import scipy; print('scipy %s' % scipy.__version__)"

if [ $USE_OPENMP == "True" ] && [ $RUNNER_OS == "Linux" ]; then
    CFLAGS="-fopenmp" LDFLAGS="-lgomp" python setup.py install
    export OMP_NUM_THREADS=4
else
    python setup.py install
fi

python -c "import cvxpy; print(cvxpy.installed_solvers())"

if [[ "$COVERAGE" == "True" ]]; then
    export WITH_COVERAGE="--with-coverage"
else
    export WITH_COVERAGE=""
fi

pytest $WITH_COVERAGE cvxpy/tests
pytest $WITH_COVERAGE cvxpy/performance_tests