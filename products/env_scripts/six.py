#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  #env.set('SIX_ROOT_DIR', env.get('PYTHON_ROOT_DIR'))
  env.set('SIX_ROOT_DIR', prereq_dir)
  pyver = 'python' + env.get('PYTHON_VERSION')
  if not platform.system() == "Windows" :
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

def set_nativ_env(env):
    pass
