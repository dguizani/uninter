#!/bin/bash

TRUE=0
FALSE=1


check_directory_exists() {
    local dir_path="$1"
    if [ -d "$dir_path" ]; then
        return $TRUE
    else
        return $FALSE
    fi
}

check_file_exists() {
    local file_path="$1"
    if [ -f "$file_path" ]; then
        return $TRUE
    else
        return $FALSE
    fi
}


VENV_DIR=""
if check_directory_exists ".venv"; then
    VENV_DIR=".venv"
elif check_directory_exists "venv"; then
    VENV_DIR="venv"
else
    echo "Virtual environment not found. Creating one..."
    VENV_DIR=".venv"
    python -m venv "$VENV_DIR"
    echo "Virtual environment '$VENV_DIR' created."
fi

echo "Using virtual environment at: $VENV_DIR"

PYTHON_EXEC_WIN="$VENV_DIR/Scripts/python.exe"
PYTHON_EXEC_OTHER="$VENV_DIR/bin/python"
PYTHON_EXEC=""

if check_file_exists "$PYTHON_EXEC_WIN"; then
    PYTHON_EXEC="$PYTHON_EXEC_WIN"
    echo "Using Windows Enviroment"
elif check_file_exists "$PYTHON_EXEC_OTHER"; then
    echo "Using Linux/macOS Enviroment"
    PYTHON_EXEC="$PYTHON_EXEC_OTHER"
else
    echo "Python executable not found in the virtual environment."
    exit $FALSE
fi

eval "$PYTHON_EXEC -m pip install --upgrade pip"

if check_file_exists "requirements.txt"; then
    eval "$PYTHON_EXEC -m pip install -r requirements.txt"
else
    echo "requirements.txt not found."
fi
