# patch pyenv local venv to also init pyright config file
function __pyright
    set -l json_line '{\n  "venvPath": "%s",\n  "venv": "%s"\n}\n'
    printf $json_line $PYENV_ROOT/versions $argv >pyrightconfig.json
end

function __local --wrap='pyenv local'
    argparse unset help -- $argv
    if set -q _flag_unset
        command pyenv local --unset
        rm -i pyrightconfig.json
        return $status
    end
    if set -q _flag_help
        command pyenv local --help
        return $status
    end
    __pyright $argv[1]
    command pyenv local $argv
    return $status
end

function __pyenv_wrapper --argument-names subcmd
    switch $subcmd
        case local
            set -e argv[1]
            __local $argv
        case activate deactivate rehash shell
            set -e argv[1]
            source (pyenv sh-$subcmd $argv | psub)
        case '*'
            command pyenv $argv
    end
end
