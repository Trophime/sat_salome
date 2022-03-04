#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    
    # SALOME_MG_KEYGEN_LIB_PATH="/path/to/libSalomeMeshGemsKeyGenerator.so"
    if platform.system() == "Windows" :
        env.prepend('SALOME_MG_KEYGEN_LIB_PATH', os.path.join(prereq_dir, 'lib', 'libSalomeMeshGemsKeyGenerator.dll'))
        pass
    else:
        env.prepend('SALOME_MG_KEYGEN_LIB_PATH', os.path.join(prereq_dir, 'lib', 'libSalomeMeshGemsKeyGenerator.so'))
        pass
    
    
    #l0=os.path.join(prereq_dir, 'lib', pyver, 'site-packages','numpy')
    #l=[os.path.join(l0,'core'),os.path.join(l0,'fft'),os.path.join(l0,'lib'),os.path.join(l0,'linalg'),os.path.join(l0,'numarray'),os.path.join(l0,'random')]
    #env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages','numpy','linalg'))

def set_nativ_env(env):
    pass
