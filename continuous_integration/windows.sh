# Download miniconda

# Get Miniconda and make it the main Python interpreter
apt-get install wget
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p ~/miniconda
export PATH=~/miniconda/bin:$PATH

echo "The PATH environment variable is"
echo $PATH
# conda update conda -y
conda init

conda config --add channels conda-forge
conda config --add channels oxfordcontrol
conda create -n testenv --yes python=$PYTHON_VERSION mkl=2018.0.3 pip pytest numpy scipy
conda activate testenv
conda install --yes lapack ecos scs
conda install -c anaconda --yes flake8
python -V
python3 -V
# pip install diffcp
pip list
python3 setup.py install
pytest cvxpy/tests