# Download miniconda

$miniconda_filename = "Miniconda3-latest-Windows-x86_64.exe"
$client = new-object System.Net.WebClient
$filepath = $pwd.Path + "\" + $miniconda_filename
$client.DownloadFile("https://repo.anaconda.com/miniconda/" + $miniconda_filename,  $filepath)

$install_args = "/InstallationType=JustMe /S /AddToPath=1 /RegisterPython=1"
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
python -V
python3 -V
pip install diffcp
pip list
python3 setup.py install
pytest cvxpy/tests