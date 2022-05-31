
# Wrap functions from individual io modules by detecting filenames

import os
from glob import glob
import itertools
import numpy as np
import h5py

# TODO not sure this is how I want names
from . import iharm3d
from .iharm3d import Iharm3DFile
from .iharm3d_restart import Iharm3DRestart
from . import kharma
from .kharma import KHARMAFile
from .harm2d import HARM2DFile
from .hamr import HAMRFile
from .koral import KORALFile

# i/o for other filetypes not tied to one code
from . import gridfile

def get_fnames(path, prefer_iharm3d=False):
    """Return what should be the list of fluid dump files in a directory 'path',
    while trying to avoid extraneous files caught in normal globs (e.g., grid.h5, other runs/filetypes)
    """
    # These are at best a touchy heuristic
    # The idea is to prefer current directory, then KHARMA subdir, then iharm3d subdir;
    # within the subdir, to prefer Parthenon strict-formatted filenames, then adjacent things, then iharm3d filenames, then harm2d
    # and finally, to prefer KHARMA file 
    # Specifically, we ant to absolutely exclude anything named grid.h5 and eht_out.h5, as well as other possible .h5 analysis files
    # We also want to exclude anything named *final.{phdf,rhdf}, these are valid output but out of cadence & can lag real output
    folders = ("dumps_kharma", "dumps", ".")
    fnames = ("*.out0.[0-9][0-9][0-9][0-9][0-9]", "*.out[0-9].[0-9][0-9][0-9][0-9][0-9]", "dump_*", "dump[0-9][0-9][0-9]")
    exts = (".phdf", ".h5", ".rhdf", "")
    if prefer_iharm3d:
        # Just prefer a "dumps" folder over "dumps_kharma."
        folders = ("dumps", "dumps_kharma", ".")

    for scheme in itertools.product(folders, fnames, exts):
        files = np.sort(glob(os.path.join(path, scheme[0], scheme[1]+scheme[2])))
        if len(files) > 0:
            # Explicitly take out some common things in dump directories
            files = [f for f in files if ("grid" not in f) and ("eht_out" not in f)]
            return files
    raise FileNotFoundError("No dump files found at {}".format(path))

def _get_filter_class(fname):
    """Internal pyharm i/o function to choose which class to use when reading a new file.
    Ideally should be kept very fast, as sometimes not much is actually *read* from the file
    afterward.
    TODO keep in mind we should print good errors called on e.g. a gridfile
    """
    if ".phdf" in fname or ".rhdf" in fname:
        return KHARMAFile
    elif ".h5" in fname:
        with h5py.File(fname, 'r') as f:
            if 'header' in f.keys():
                if 'KORAL' in f["/header/version"][()].decode('UTF-8'):
                    return KORALFile
                else:
                    return Iharm3DFile
            elif 'restart_id' in f.keys():
                return Iharm3DRestart
            else:
                return KHARMAFile
    elif ".hdf5" in fname:
            return HAMRFile
    elif "dump" in fname:
        # HARM ASCII files are *usually* named "dump" with a number
        return HARM2DFile
    else:
        print("Guessing filetype harm2d!")
        return HARM2DFile

def get_dump_time(fname):
    """Quickly get just the simulation time represented in the dump file.
    For cutting on time without loading everything
    """
    return _get_filter_class(fname).get_dump_time(fname)

def read_hdr(fname):
    """Get just the header/params embedded in a simulation file.
    """
    return _get_filter_class(fname)(fname).read_params()

def read_log(fname):
    """Read a file containing a history or log of fluxes & other scalars over time.
    """
    if ".hst" in fname:
        return kharma.read_log(fname)
    elif ".log" in fname:
        return iharm3d.read_log(fname)

def file_reader(fname, **kwargs):
    """Return an XFile object ("filter") which can read/write the given filename.
    This guesses based on filename, mostly, or very basic file contents.
    You can override it by just constructing a filter of your desired type.
    :param fname: A filename (or HDF5 file handle)

    Note that you can use this more easily through the FluidDump object
    """
    # This gets the class with _get_filter(fname),
    # and the subsequent call (fname) constructs one
    return _get_filter_class(fname)(fname, **kwargs)
