# Dracula (own)
set -l selection  636683
set -l comment    6272A4

set -l red    FF5555
set -l orange FFB86C
set -l yellow F4F99D
set -l green  50FA7B
set -l pink   FF79C6
set -l purple BD93F9
set -l white  F8F8F2
set -l blue   8BE9FD

set -g fish_color_autosuggestion $selection
set -g fish_color_command        $white
set -g fish_color_comment        $comment
set -g fish_color_end            $green
set -g fish_color_error          $red
set -g fish_color_escape         $yellow
set -g fish_color_operator       $orange
set -g fish_color_param          $pink
set -g fish_color_quote          $yellow
set -g fish_color_redirection    $blue
set -g fish_color_search_match   --background=$selection
set -g fish_color_selection      --background=$selection

