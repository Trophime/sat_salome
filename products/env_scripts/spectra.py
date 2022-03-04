#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env, prereq_dir, version):
  env.set('SPECTRA_ROOT_DIR', prereq_dir)
  env.set('spectra_DIR', os.path.join(prereq_dir, 'include','Spectra'))

def set_nativ_env(env):
    pass
