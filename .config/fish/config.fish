#!/usr/bin/env fish
set fish_greeting

set -gx EDITOR nvim
set -gx LANG en_US.UTF-8

fish_add_path ~/bin
fish_add_path /usr/local/bin
fish_add_path /usr/bin
fish_add_path /usr/local/sbin
fish_add_path /usr/bin/site_perl
fish_add_path /usr/bin/vendor_perl
fish_add_path /usr/bin/core_perl

set -Ux PIP_REQUIRE_VIRTUALENV true
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

pyenv init - | source
pyenv virtualenv-init - | source

# patch pyenv local to support init of pyright config
# note: patching must happen here because pyenv init defines a pyenv function
function pyenv --wrap='pyenv'
    __pyenv_wrapper $argv
end
