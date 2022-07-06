
import numpy as np
import matplotlib.pyplot as plt

import pyharm
from pyharm.defs import Loci


def _get_t_slice(result, kwargs):
    # Returns a boolean along with the slice.
    # If true, indicates no slice was taken, i.e. caller should (split by window and) plot all time
    if kwargs['avg_min'] is not None:
        try:
            # get_time_slice doesn't require this but we print it
            if kwargs['avg_max'] is None:
                kwargs['avg_max'] = result['t'][-1]
            avg_slice = result.get_time_slice(kwargs['avg_min'], kwargs['avg_max'])
        except KeyError:
            return False, None
        return False, avg_slice
    else:
        return True, slice(None)

def _get_r_slice(result, kwargs, default):
    """Get a slice of radial zones matching the plot window.
    Plotting only the necessary radial range makes auto-scaling of the y-axis work"""
    if kwargs['xmax'] is None:
        kwargs['xmax'] == default
    else:
        kwargs['xmax'] = float(kwargs['xmax'])
    return pyharm.util.i_of(result['r'], kwargs['xmax'])

def initial_conditions_overplot(results, kwargs):
    return initial_conditions(results, kwargs, overplot=True)

def initial_conditions(results, kwargs, overplot=False): # TODO radial_averages_at
    """
    """
    if kwargs['varlist'] is None:
        vars=('rho', 'Pg', 'b', 'bsq', 'Ptot', 'u^3', 'sigma_post', 'inv_beta_post')

    nx = min(len(vars), 4)
    ny = (len(vars)-1)//4+1
    if overplot:
        fig, _ = plt.subplots(ny, nx, figsize=(4*nx,4*ny))
        ax = fig.get_axes()

    for result in results.values():
        # Event horizon fluxes
        ir = pyharm.util.i_of(result['r'], 500)
        if not overplot:
            fig, _ = plt.subplots(ny, nx, figsize=(4*nx,4*ny))
            ax = fig.get_axes()
        for a,var in enumerate(vars):
            ax[a].plot(result['r'][:ir], result['rt/{}_disk'.format(var)][0, :ir], label=result.tag)
            ax[a].set_ylabel(pyharm.pretty(var), rotation=0, ha='right') #sep
            ax[a].grid(True)
            ax[a].set_xlim(2, 1000)
            ax[a].set_yscale('log')
            ax[a].set_xscale('log')
        if not overplot:
            _savefig(fig, "initial_conditions_"+result.tag, kwargs)

    if overplot:
        ax[0].legend()
        _savefig(fig, "initial_conditions", kwargs)

def plot_eh_fluxes(ax, result, per=False):
    if per:
        tag = '_per'
    else:
        tag = ''
    for a,var in enumerate(('mdot', 'phi_b'+tag, 'abs_ldot'+tag, 'eff'+tag)):
        ax[a].plot(result['t'], result['t/{}'.format(var)], label=result.tag)
        ax[a].set_ylabel(pyharm.pretty(var), rotation=0, ha='right')
        ax[a].grid(True)

def plot_eh_phi_versions(ax, result):
    for a,var in enumerate(('phi_b', 'phi_b_upper', 'phi_b_lower')):
        ax[a].plot(result['t'], result['t/{}'.format(var)], label=result.tag)
        ax[a].set_ylabel(pyharm.pretty(var), rotation=0, ha='right')
        ax[a].grid(True)
    # Additionally plot
    ax[0].plot(result['t'], np.abs(result['t/phi_b_upper'])+np.abs(result['t/phi_b_lower']), label=result.tag+" hemispheres")

def eh_fluxes(results, kwargs):
    for result in results.values():
        # Event horizon fluxes
        fig, _ = plt.subplots(4,1, figsize=(7,7))
        axes = fig.get_axes()
        plot_eh_fluxes(axes, result)
        plt.subplots_adjust(wspace=0.4)
        _savefig(fig, "eh_fluxes_"+result.tag, kwargs)

def eh_fluxes_per(results, kwargs):
    for result in results.values():
        print(result.fname)
        # Event horizon fluxes
        fig, _ = plt.subplots(4,1, figsize=(7,7))
        axes = fig.get_axes()
        plot_eh_fluxes(axes, result, per=True)
        plt.subplots_adjust(wspace=0.4)
        _savefig(fig, "eh_fluxes_per_"+result.tag, kwargs)

def eh_phi_versions(results, kwargs):
    for result in results.values():
        # Event horizon fluxes
        fig, _ = plt.subplots(3,1, figsize=(7,7))
        axes = fig.get_axes()
        plot_eh_phi_versions(axes, result)
        plt.subplots_adjust(wspace=0.4)
        _savefig(fig, "eh_phi_versions_"+result.tag, kwargs)

def overplot_eh_phi_versions(results, kwargs):
    for result in results.values():
        # Event horizon fluxes
        fig, _ = plt.subplots(3,1, figsize=(7,7))
        axes = fig.get_axes()
        plot_eh_phi_versions(axes, result)
        plt.subplots_adjust(wspace=0.4)
        _savefig(fig, "eh_phi_versions_"+result.tag, kwargs)

def overplot_eh_fluxes(results, kwargs):
    fig, _ = plt.subplots(4,1, figsize=(7,7))
    ax = fig.get_axes()
    for result in results.values():
        plot_eh_fluxes(ax, result)

    ax[0].legend()
    plt.subplots_adjust(wspace=0.4)
    _savefig(fig, "eh_fluxes_compare", kwargs)

def plot_radial_averages(ax, result, kwargs, default_r=50):
    window, avg_slice = _get_t_slice(result, kwargs)
    ir = _get_r_slice(result, kwargs, default=default_r)

    for a,var in enumerate(('FM', 'FE', 'FL')):
        if window:
            for i in range(1,6):
                slc = result.get_time_slice(i*5000, (i+1)*5000)
                ax[a].plot(result['r'][:ir], np.mean(result['rt/{}_disk'.format(var)][slc, :ir], axis=0),
                            label=r"{}-{} $\frac{{r_g}}{{c^2}}$".format(i*5000, (i+1)*5000))
        else:
            ax[a].plot(result['r'][:ir], np.mean(result['rt/{}_disk'.format(var)][avg_slice, :ir], axis=0),
                        label=r"{}-{} $\frac{{r_g}}{{c^2}}$".format(int(kwargs['avg_min']), int(kwargs['avg_max'])))
        ax[a].set_ylabel(pyharm.pretty(var))

    ax[0].legend()
    plt.subplots_adjust(wspace=0.4)
    return window

def radial_averages(results, kwargs):
    if kwargs['vars'] is None:
        vars = ('rho', 'Pg', 'b', 'bsq', 'Ptot', 'u^3', 'sigma_post', 'inv_beta_post')
    else:
        vars = kwargs['vars']

    for result in results.values():
        # Radial profiles of variables
        nx = min(len(vars), 4)
        ny = (len(vars)-1)//4+1
        fig, _ = plt.subplots(ny, nx, figsize=(4*nx,4*ny))
        ax = fig.get_axes()

        window = plot_radial_averages(ax, results, kwargs, default_r=50)

        if window:
            _savefig(fig, "radial_averages_by_window_"+result.tag, kwargs)
        else:
            _savefig(fig, "radial_averages_"+result.tag, kwargs)
        

def radial_fluxes(results, kwargs):
    for result in results.values():
        fig, _ = plt.subplots(1,3, figsize=(14,4))
        ax = fig.get_axes()
        window = plot_radial_averages(ax, results, kwargs, default_r=20)
        if window:
            _savefig(fig, "radial_fluxes_by_window_"+result.tag, kwargs)
        else:
            _savefig(fig, "radial_fluxes_"+result.tag, kwargs)


def disk_momentum(results, kwargs):
    kwargs['vars'] = "u_3"
    return radial_averages(results, kwargs)

def _model_pretty(folder):
    model = folder.split("/")
    if len(model) >= 2:
        if "_" in model[-1]:
            return model[-3]
        return model[-2].upper()+r" $"+model[-1]+r"^\circ$"
    else:
        return folder

def plot_val_vs_res(results, ax, kwargs, to_plot):
    """Average of a scalar time-dependent flux vs resolution for any model combination"""
    var = kwargs['varlist'][0]

    model_res = {}
    model_vals = {}
    # Run through the files and suck up everything
    for result in results.values():
        # If this thing is even readable...
        window, avg_slice = _get_t_slice(result, kwargs)
        if window:
            raise ValueError("Cannot compute an average without a range!")
        if avg_slice is None:
            print("Skipping {}".format(result.tag))
            continue

        model = " ".join(result.tag.split(" ")[:-1])
        res = int(result.tag.split(" ")[-1].split("X")[0])
        if model not in model_res:
            model_res[model] = []
            model_vals[model] = []
        model_res[model].append(res)

        if to_plot == 'avg':
            val = np.mean(result['t/'+var][avg_slice])
        elif to_plot == 'std':
            val = np.std(result['t/'+var][avg_slice])
        model_vals[model].append(val)
    
    # Then plot each model
    for model in model_res.keys():
        spins, var_vs_spin = zip(*sorted(zip(model_res[model], model_vals[model]), key=lambda x: x[0]))
        ax.plot(spins, var_vs_spin, '.--', label=_model_pretty(model))

def plot_val_vs_spin(results, ax, kwargs, to_plot):
    """Average of a scalar time-dependent flux vs spin for any model combination"""
    var = kwargs['varlist'][0]

    model_spins = {}
    model_vals = {}
    # Run through the files and suck up everything
    for result in results.values():
        print("Plotting result {}".format(result.tag))
        model = " ".join(result.tag.split(" ")[:-1])
        spin = float(result.tag.split(" ")[-1].lstrip("A"))
        if model not in model_spins:
            model_spins[model] = []
            model_vals[model] = []
        model_spins[model].append(spin)

        window, avg_slice = _get_t_slice(result, kwargs)
        if window:
            raise ValueError("Cannot compute an average without a range!")

        if to_plot == 'avg':
            val = np.mean(result['t/'+var][avg_slice])
        elif to_plot == 'std':
            val = np.std(result['t/'+var][avg_slice])
        model_vals[model].append(val)
    
    # Then plot each model
    for model in model_spins.keys():
        spins, var_vs_spin = zip(*sorted(zip(model_spins[model], model_vals[model]), key=lambda x: x[0]))
        ax.plot(spins, var_vs_spin, '.--', label=_model_pretty(model))

def _point_per_run(results, kwargs, to_plot, plot_vs):
    fig, _ = plt.subplots(1, 1, figsize=(7,7))
    axis = fig.get_axes()[0]

    if plot_vs == 'spin':
        plot_val_vs_spin(results, axis, kwargs, to_plot=to_plot)
    elif plot_vs == 'res':
        plot_val_vs_res(results, axis, kwargs, to_plot=to_plot)

    axis.grid(True)

    if plot_vs == 'spin':
        plt.xlim(-1,1)
        plt.xlabel(r"Spin $a_*$")
    elif plot_vs == 'res':
        plt.xlabel(r"Radial resolution")

    if kwargs['ymin'] is not None:
        kwargs['ymin'] = float(kwargs['ymin'])
    if kwargs['ymax'] is not None:
        kwargs['ymax'] = float(kwargs['ymax'])
    plt.ylim(kwargs['ymin'], kwargs['ymax'])
    plt.ylabel(pyharm.pretty(kwargs['varlist'][0]))

    plt.legend()
    return fig

# TODO add avg/std bars as needed
def std_vs_spin(results, kwargs):
    fig = _point_per_run(results, kwargs, 'std', 'spin')
    _savefig(fig, "std_vs_spin_"+kwargs['varlist'][0], kwargs)
def avg_vs_spin(results, kwargs):
    fig = _point_per_run(results, kwargs, 'avg', 'spin')
    _savefig(fig, "avg_vs_spin_"+kwargs['varlist'][0], kwargs)
def std_vs_res(results, kwargs):
    fig = _point_per_run(results, kwargs, 'std', 'res')
    _savefig(fig, "std_vs_res_"+kwargs['varlist'][0], kwargs)
def avg_vs_res(results, kwargs):
    fig = _point_per_run(results, kwargs, 'avg', 'res')
    _savefig(fig, "avg_vs_res_"+kwargs['varlist'][0], kwargs)