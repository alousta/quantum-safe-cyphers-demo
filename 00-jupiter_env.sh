#!/bin/bash

# Script to create a Python virtual environment, install JupyterLab, Jupyter Notebook, and Voila,
# and create aliases for activation/deactivation and removal.

VENV_NAME="my_jupyter_env"
VENV_PATH="$HOME/$VENV_NAME"

# Function to create the virtual environment and install packages
create_venv() {
  echo "Creating virtual environment: $VENV_NAME"
  python3 -m venv "$VENV_PATH"

  if [ $? -ne 0 ]; then
    echo "Error creating virtual environment."
    return 1
  fi

  echo "Activating virtual environment..."
  source "$VENV_PATH/bin/activate"

  echo "Installing JupyterLab, Jupyter Notebook, qiskit qiskit-ibm-runtime and Voila..."
  pip install --upgrade pip
  pip install jupyterlab notebook voila qiskit qiskit-ibm-runtime

  if [ $? -ne 0 ]; then
    echo "Error installing packages."
    deactivate
    return 1
  fi

  deactivate
  echo "Virtual environment created and packages installed successfully."
  return 0
}

# Function to activate the virtual environment
activate_venv() {
  source "$VENV_PATH/bin/activate"
  echo "Virtual environment activated."
}

# Function to deactivate the virtual environment
deactivate_venv() {
  deactivate
  echo "Virtual environment deactivated."
}

# Function to remove the virtual environment
remove_venv() {
  echo "Removing virtual environment: $VENV_NAME"
  if [ -d "$VENV_PATH" ]; then
    rm -rf "$VENV_PATH"
    echo "Virtual environment removed."
  else
    echo "Virtual environment not found."
  fi
}

# Add aliases to the user's .bashrc or .zshrc
add_aliases() {
  local rc_file
  if [[ -f "$HOME/.bashrc" ]]; then
    rc_file="$HOME/.bashrc"
  elif [[ -f "$HOME/.zshrc" ]]; then
    rc_file="$HOME/.zshrc"
  else
    echo "No .bashrc or .zshrc found. Please add the aliases manually."
    return 1
  fi

  echo "Adding aliases to $rc_file..."

  echo "alias jenv_activate='source $VENV_PATH/bin/activate'" >> "$rc_file"
  echo "alias jenv_deactivate='deactivate'" >> "$rc_file"
  echo "alias jenv_remove='bash -c \"$(declare -f remove_venv); remove_venv\"'" >> "$rc_file"

  echo "Aliases added. Please source your $rc_file or open a new terminal."
  return 0
}

# Main script logic
if [ "$1" == "create" ]; then
  create_venv
elif [ "$1" == "activate" ]; then
  activate_venv
elif [ "$1" == "deactivate" ]; then
  deactivate_venv
elif [ "$1" == "remove" ]; then
  remove_venv
elif [ "$1" == "aliases" ]; then
  add_aliases
else
  echo "Usage: $0 [create|activate|deactivate|remove|aliases]"
  exit 1
fi

exit 0