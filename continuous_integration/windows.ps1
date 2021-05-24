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

$env:PATH = "${env:PYTHON};${env:PYTHON}\Scripts;" + $env:PATH
echo "The PATH environment variable is"
echo $env:PATH
# conda update conda -y
conda init

conda config --add channels conda-forge
conda config --add channels oxfordcontrol
conda create -n testenv --yes python=$env:PYTHON_VERSION mkl=2018.0.3 pip pytest numpy scipy
conda activate testenv
"python=$PYTHON_VERSION" | Out-File C:\conda\envs\testenv\conda-meta\pinned -encoding ascii
conda install --yes lapack ecos scs
conda install -c anaconda --yes flake8
pip install diffcp
python setup.py install