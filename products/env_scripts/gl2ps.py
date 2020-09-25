#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('GL2PSDIR', prereq_dir)
  env.set('GL2PS_ROOT_DIR', prereq_dir)
    
  env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

  if not platform.system() == "Windows" :
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
  pass
