
# If anything fails, exit
set -eo pipefail

# Function to display usage information
function display_help() {
	cat <<EOM
Usage: $0 -d <download-dir> -g <git_url_repo>
Options:
  -d       Specify directory for storing Neovim binaries.
  -g       Specify the git url repository
  -h       Display this help message and exit.
EOM
}

# Function to check if git is available in the system's $PATH
function check_git_in_path() {
	if ! command -v git &>/dev/null; then
		echo "Git is not installed. Exiting..."
		exit 0
	fi
}


# Function to install Neovim
function install_neovim_config() {
	# Check if the specified download directory exists
	if [[ ! -d $remote_nvim_dir ]]; then
		echo "Remote neovim directory does not exist."
		exit 0
	fi

    # Clone the repository into the remote Neovim directory
    git clone $git_url_repo $remote_nvim_dir

    # Check if the clone was successful
    if [[ $? -ne 0 ]]; then
        echo "Failed to clone the repository."
        exit 1
    fi

    echo "Neovim configuration successfully cloned into $remote_nvim_dir"
}

# Parse command-line options
while getopts "d:g:h" opt; do
	case $opt in
	d)
		remote_nvim_dir="$OPTARG"
		;;
    g)
		git_url_repo="$OPTARG"
		;;
	h)
		display_help
		exit 0
		;;
	\?)
		display_help
		exit 1
		;;
	:)
		echo "Option -$OPTARG requires an argument." >&2
		display_help
		exit 1
		;;
	esac
done
# TODO
# Check if the required options are provided
# if [[ -z $remote_nvim_dir || -z $git_url_repo ]]; then
# 	echo "Missing options. Use -h to see the usage."
# 	exit 1
# fi

install_neovim_config
