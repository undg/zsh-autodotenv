#!/usr/bin/env zsh
  
ANSWER=false

function askYesNo {
    echo -n " $1 [Yes/no]: "
    read -r INPUT

    if [[ "$INPUT" =~ ^[yY]$ ]]; then
        echo 'yes'
        ANSWER=true
    else
        echo 'No'
        ANSWER=false
    fi
}

function source_env() {
    if [[ -f .env ]]; then
        # test .env syntax
        zsh -fn .env || echo 'dotenv: error when sourcing `.env` file' >&2

        askYesNo "Load environment variables used in .env file?" true

        if [[ "$ANSWER" = true ]]; then
            echo "Loading .env file..."
            if [[ -o a ]]; then
                source .env
            else
                set -a
                source .env
                set +a
            fi
            echo ".env file loaded"
        else
            echo "Ok! Bye"
        fi
    fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd source_env

source_env
