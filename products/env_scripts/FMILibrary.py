#!/usr/bin/env python
import os.path

def set_env(env, prereq_dir, version):
    env.set('FMILIBRARY_ROOT_DIR', prereq_dir)
    env.set('FMIL_HOME',prereq_dir)
    env.prepend('PATH', os.path.join(prereq_dir,'bin'))
    env.prepend('LD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
    pass
