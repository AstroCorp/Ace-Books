#!/bin/bash

ENV_FILE="./.env"
FRONTEND_DIR="./Ace-Books-Frontend"
BACKEND_DIR="./Ace-Books-Backend"

# Si no existe el directorio del frontend, clonar el repositorio
if [ ! -d "$FRONTEND_DIR" ]; then
    git clone git@github.com:AstroCorp/Ace-Books-Frontend.git
fi

# Si no existe el directorio del backend, clonar el repositorio
if [ ! -d "$BACKEND_DIR" ]; then
    git clone git@github.com:AstroCorp/Ace-Books-Backend.git
fi

# Comprobar si el archivo .env existe
if [ -f "$ENV_FILE" ]; then
    read -p "The .env file already exists. Do you want to replace it? (y/N): " REPLACE

    if [ "$REPLACE" != "y" ]; then
        echo "The .env file will not be replaced."
    else
        # Crear el archivo .env combinando los .env.example de frontend y backend
        {
            echo "# --- Frontend ---"
            echo ""
            cat "$FRONTEND_DIR/.env.example"
            echo ""
            echo "# --- Backend ---"
            echo ""
            cat "$BACKEND_DIR/.env.example"
        } > "$ENV_FILE"

        echo ".env file generated with the content from the frontend and backend .env.example files"
    fi
fi

# Crear enlaces simbólicos en el frontend y en el backend para gestionar el .env
if [[ "$OSTYPE" == "msys" ]]; then
    cmd //c "cd %CD%\\Ace-Books-Frontend && mklink /H .env ..\.env"
else
    cd ./Ace-Books-Frontend && ln -s "../.env" ".env"
fi

if [[ "$OSTYPE" == "msys" ]]; then
    cmd //c "cd %CD%\\Ace-Books-Backend && mklink /H .env ..\.env"
else
    cd ../Ace-Books-Backend && ln -s "../.env" ".env"
fi

echo "Symbolic links created in $FRONTEND_DIR and $BACKEND_DIR"
