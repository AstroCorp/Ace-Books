#!/bin/bash

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_BLUE='\033[0;34m'
COLOR_DEFAULT='\033[0m'

ENV_FILE="./.env"
FRONTEND_DIR="./Ace-Books-Frontend"
BACKEND_DIR="./Ace-Books-Backend"

generate_env_file() {
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

    echo -e "${COLOR_GREEN}.env file generated with the content from the frontend and backend .env.example files.${COLOR_DEFAULT}"
}

# Si no existe el directorio del frontend, clonar el repositorio
if [ ! -d "$FRONTEND_DIR" ]; then
    git clone git@github.com:AstroCorp/Ace-Books-Frontend.git
    
    echo -e "${COLOR_GREEN}Frontend repository cloned.${COLOR_DEFAULT}"
else
    echo -e "${COLOR_YELLOW}The frontend directory already exists.${COLOR_DEFAULT}"
fi

# Si no existe el directorio del backend, clonar el repositorio
if [ ! -d "$BACKEND_DIR" ]; then
    git clone git@github.com:AstroCorp/Ace-Books-Backend.git

    echo -e "${COLOR_GREEN}Backend repository cloned.${COLOR_DEFAULT}"
else
    echo -e "${COLOR_YELLOW}The backend directory already exists.${COLOR_DEFAULT}"
fi

# Comprobar si el archivo .env existe
if [ -f "$ENV_FILE" ]; then
    echo -e "${COLOR_BLUE}The .env file already exists. Do you want to replace it? (y/N):${COLOR_DEFAULT}"

    read -p "" REPLACE

    if [ "$REPLACE" != "y" ]; then
        echo -e "${COLOR_YELLOW}The .env file will not be replaced.${COLOR_DEFAULT}"
    else
        # Eliminar el archivo .env
        rm "$ENV_FILE"

        generate_env_file
    fi
else
    generate_env_file
fi

# Crear enlaces simbólicos en el frontend y en el backend para gestionar el .env
if [ ! -f "$FRONTEND_DIR/.env" ]; then
    # Eliminamos el .env antes de crear el enlace simbólico
    if [ -f "$FRONTEND_DIR/.env" ]; then
        rm "$FRONTEND_DIR/.env"
    fi

    # Creamos el enlace simbólico tenido en cuenta el sistema operativo
    if [[ "$OSTYPE" == "msys" ]]; then
        cmd //c "cd %CD%\\Ace-Books-Frontend && mklink /H .env ..\.env"
    else
        cd ./Ace-Books-Frontend && ln -s "../.env" ".env"
    fi

    echo -e "${COLOR_GREEN}Symbolic link created in $FRONTEND_DIR${COLOR_DEFAULT}"
else
    echo -e "${COLOR_YELLOW}The symbolic link in $FRONTEND_DIR already exists.${COLOR_DEFAULT}"
fi

if [ ! -f "$BACKEND_DIR/.env" ]; then
    # Eliminamos el .env antes de crear el enlace simbólico
    if [ -f "$BACKEND_DIR/.env" ]; then
        rm "$BACKEND_DIR/.env"
    fi

    # Creamos el enlace simbólico tenido en cuenta el sistema operativo
    if [[ "$OSTYPE" == "msys" ]]; then
        cmd //c "cd %CD%\\Ace-Books-Backend && mklink /H .env ..\.env"
    else
        cd ../Ace-Books-Backend && ln -s "../.env" ".env"
    fi

    echo -e "${COLOR_GREEN}Symbolic link created in $BACKEND_DIR${COLOR_DEFAULT}"
else
    echo -e "${COLOR_YELLOW}The symbolic link in $BACKEND_DIR already exists.${COLOR_DEFAULT}"
fi

echo -e "${COLOR_GREEN}Symbolic links created in $FRONTEND_DIR and $BACKEND_DIR${COLOR_DEFAULT}"
