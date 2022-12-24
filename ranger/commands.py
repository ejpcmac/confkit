import os
import subprocess

import ranger.api.commands as ranger

class fd(ranger.Command):
    def execute(self):
        type_ = self.arg(1)
        path = self.arg(2)
        extra_args = "--hidden --no-ignore" if self.arg(3) else ""

        command = f"fd --type {type_} --follow {extra_args} . {path} | fzf"

        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)
