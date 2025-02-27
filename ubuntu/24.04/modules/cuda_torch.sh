#!/bin/bash

# Get installed CUDA version using nvcc and properly extract the version number
CUDA_VERSION=$(nvcc --version | grep "release" | awk '{print $NF}' | cut -d',' -f1 | sed 's/^V//')

if [ -z "$CUDA_VERSION" ]; then
    echo "CUDA not found. Installing the CPU version of PyTorch."
    TORCH_URL="https://download.pytorch.org/whl/cpu"
    TORCH_VERSION="torch"
else
    CUDA_MAJOR=$(echo $CUDA_VERSION | cut -d. -f1)
    CUDA_MINOR=$(echo $CUDA_VERSION | cut -d. -f2)
    
    echo "Detected CUDA version: ${CUDA_MAJOR}.${CUDA_MINOR}"

    # Determine the appropriate PyTorch version and download URL based on CUDA version
    case "${CUDA_MAJOR}.${CUDA_MINOR}" in
        12.2)
            TORCH_VERSION="torch==2.1.0+cu122"
            TORCH_URL="https://download.pytorch.org/whl/cu122"
            ;;
        12.1)
            TORCH_VERSION="torch==2.1.0+cu121"
            TORCH_URL="https://download.pytorch.org/whl/cu121"
            ;;
        12.0)
            TORCH_VERSION="torch==2.1.0+cu120"
            TORCH_URL="https://download.pytorch.org/whl/cu120"
            ;;
        11.8)
            TORCH_VERSION="torch==2.1.0+cu118"
            TORCH_URL="https://download.pytorch.org/whl/cu118"
            ;;
        11.7)
            TORCH_VERSION="torch==1.13.1+cu117"
            TORCH_URL="https://download.pytorch.org/whl/cu117"
            ;;
        11.6)
            TORCH_VERSION="torch==1.13.1+cu116"
            TORCH_URL="https://download.pytorch.org/whl/cu116"
            ;;
        11.4 | 11.5)
            TORCH_VERSION="torch==1.10.0+cu115"
            TORCH_URL="https://download.pytorch.org/whl/cu115"
            ;;
        11.3)
            TORCH_VERSION="torch==1.10.0+cu113"
            TORCH_URL="https://download.pytorch.org/whl/cu113"
            ;;
        11.1 | 11.2)
            TORCH_VERSION="torch==1.10.1+cu111"
            TORCH_URL="https://download.pytorch.org/whl/cu111"
            ;;
        11.0)
            TORCH_VERSION="torch==1.7.1+cu110"
            TORCH_URL="https://download.pytorch.org/whl/cu110"
            ;;
        10.2)
            TORCH_VERSION="torch==1.9.1+cu102"
            TORCH_URL="https://download.pytorch.org/whl/cu102"
            ;;
        10.1)
            TORCH_VERSION="torch==1.4.0+cu101"
            TORCH_URL="https://download.pytorch.org/whl/cu101"
            ;;
        10.0)
            TORCH_VERSION="torch==1.2.0+cu100"
            TORCH_URL="https://download.pytorch.org/whl/cu100"
            ;;
        9.2)
            TORCH_VERSION="torch==1.1.0+cu92"
            TORCH_URL="https://download.pytorch.org/whl/cu92"
            ;;
        *) 
            echo "No matching PyTorch version found for this CUDA version. Installing the CPU version."
            TORCH_VERSION="torch"
            TORCH_URL="https://download.pytorch.org/whl/cpu"
            ;;
    esac
fi

# Ask for confirmation before installing
echo "PyTorch installation details:"
echo "  - Version: $TORCH_VERSION"
echo "  - Repository: $TORCH_URL"
read -p "Do you want to proceed with the installation? (y/n): " CONFIRM

if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Installing PyTorch..."
    pip install "$TORCH_VERSION" --index-url "$TORCH_URL"
    echo "Installation completed."
else
    echo "Installation canceled."
fi
