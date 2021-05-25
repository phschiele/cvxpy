# Download miniconda

choco install miniconda3 --params="'/AddToPath:1'"

# Update conda and call "conda init" to handle path management issues on Windows

echo "The PATH environment variable is"
echo $env:PATH
# conda update conda -y
conda init

conda config --add channels conda-forge
conda config --add channels oxfordcontrol
conda create -n testenv --yes python=$env:PYTHON_VERSION mkl=2018.0.3 pip pytest numpy scipy
conda activate testenv
conda install --yes lapack ecos scs
conda install -c anaconda --yes flake8
python -V
python3 -V
pip install diffcp
pip list
python3 setup.py install
pytest cvxpy/tests