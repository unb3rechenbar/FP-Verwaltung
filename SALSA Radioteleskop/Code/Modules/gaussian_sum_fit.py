import numpy as np
import argparse
from os import path

from scipy.optimize import curve_fit
from scipy.signal import argrelextrema

# >------------ Functions ------------<
def gaussian(x, amp, cen, wid):
    return amp * np.exp(-(x-cen)**2 / (2*(wid)**2))

def gaussian_sum(x, *params):
    y = np.zeros_like(x)
    for i in range(0, len(params), 3):
        y += gaussian(x, params[i], params[i+1], params[i+2])
    return y

def fit_gaussian_sum(x, y, initial_guess):
    popt, pcov = curve_fit(gaussian_sum, x, y, p0=initial_guess)
    return popt

def find_local_maxima(y, threshold):
    yrelevant=np.where(y>threshold, y, 0)
    return argrelextrema(yrelevant, np.greater, order=1)

# >------------ parse arguments ------------<
def parse_args():
    parser = argparse.ArgumentParser(description='Fit Gaussian sum to data')
    parser.add_argument('--input-path', '-i', type=str, required=True, help='Path to spectrum file')
    parser.add_argument('--initial-guess', '-g', type=float, nargs='+', help='Initial guess for Gaussian parameters')
    parser.add_argument('--galactic-length', '-l', type=float, help='Galactic length')

    return parser.parse_args()

# >------------ main ------------<
def main():
    args = parse_args()

    # Load data
    data = np.loadtxt(args.input_path)
    x, y = data[:, 0], data[:, 1]

    guessed_amps=y[find_local_maxima(y, 5)]
    guessed_cents=x[find_local_maxima(y, 5)]

    guess=zip(guessed_amps, guessed_cents,[5]*len(guessed_amps))

    # make list from guess
    guess_list = [item for sublist in guess for item in sublist]

    print("    Identified peaks: ")
    print("    -----------------------------")
    print("    Amplitude  Center (x-value)")
    print("    -----------------------------")
    for i in range(len(guessed_amps)):
        print(f"    {guessed_amps[i]:.2f}     {guessed_cents[i]:.2f}")
    print("    -----------------------------")

    print("    Initial guess: ")
    print("    -----------------------------")
    print("    Amplitude  Center (x-value)  Width")
    print("    -----------------------------")
    for i in range(0, len(guess_list), 3):
        print(f"    {guess_list[i]:.2f}     {guess_list[i+1]:.2f}     {guess_list[i+2]:.2f}")
    print("    -----------------------------\n")

    # Fit data
    popt = fit_gaussian_sum(x, y, guess_list if args.initial_guess is None else args.initial_guess)

    print(f'    Function Parameters of individual Gaussians:')
    print("    -----------------------------")
    print("    Amplitude  Center (x-value)  Width")
    print("    -----------------------------")
    for i in range(0, len(popt), 3):
        print(f"    {popt[i]:.2f}     {popt[i+1]:.2f}     {popt[i+2]:.2f}")
    print("    -----------------------------\n")

    # Save fit data
    output_path = path.join(path.dirname(args.input_path), f'fit_{path.basename(args.input_path)}')
    np.savetxt(output_path, np.column_stack((x, gaussian_sum(x, *popt))), delimiter=' ', fmt='%1.6f')
    print(f'      <-> module gaussian_sum_fit.py: Fitted Gaussian sum saved as "fit_{path.basename(args.input_path)}"')

    # save peak data
    peak_output_path = path.join(path.dirname(args.input_path), f'peaks_{path.basename(args.input_path)}')
    np.savetxt(peak_output_path, np.column_stack((guessed_cents, guessed_amps)), delimiter=' ', fmt='%1.6f')

    # save fit parameters
    fit_output_path = path.join(path.dirname(args.input_path), f'fit_parameters_{path.basename(args.input_path)}')

    np.savetxt(fit_output_path, np.column_stack((popt[0::3], popt[1::3], popt[2::3])), delimiter=' ', fmt='%1.6f')


# >------------ execute ------------<
if __name__ == '__main__':
    main()