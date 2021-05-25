# Download miniconda

$miniconda_filename = "Miniconda3-py39_4.9.2-Windows-x86_64.exe"
$miniconda_url = "https://repo.continuum.io/miniconda/"
$fileurl = $miniconda_url + $miniconda_filename
$filepath = $pwd.Path + "\" + $miniconda_filename
$client = new-object System.Net.WebClient
$client.DownloadFile($fileurl,  $filepath)

# Install miniconda

$install_args = "/InstallationType=JustMe /S /RegisterPython=1 /D=" + $env:PYTHON
Write-Host $filepath $install_args
Start-Process -Filepath $filepath -ArgumentList $install_args -Wait -Passthru

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
pip install diffcp pytest
python setup.py install
pytest cvxpy/tests