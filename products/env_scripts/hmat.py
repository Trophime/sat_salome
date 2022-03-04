#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env, prereq_dir, version):
  env.set('HMAT_ROOT_DIR', prereq_dir)
  env.set('hmat_DIR', os.path.join(prereq_dir, 'include','hmat'))

def set_nativ_env(env):
    pass
