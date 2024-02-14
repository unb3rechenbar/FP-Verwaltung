import numpy as np
import argparse

from os import path
from scipy.ndimage import convolve1d
from scipy.ndimage import gaussian_filter


# >------------ Smoothing Functions ------------<
def smooth_data(x, y, sigma):
    smoothed = gaussian_filter(y, sigma=sigma, mode='nearest')
    return x, smoothed


# >------------ parse arguments ------------<
def parse_args():
    parser = argparse.ArgumentParser(description='Smoothing data')
    parser.add_argument('--input-path', '-i', type=str, required=True, help='Path to spectrum file')
    parser.add_argument('--sigma', '-s', type=float, required=True, help='Sigma for smoothing')

    return parser.parse_args()

# >------------ main ------------<
def main():
    args = parse_args()

    # Load data
    data = np.loadtxt(args.input_path)
    x, y = data[:, 0], data[:, 1]

    # Smooth data
    x, smoothed = smooth_data(x, y, args.sigma)

    # Save data
    output_path = path.join(path.dirname(args.input_path), f'smoothed_{path.basename(args.input_path)}')
    np.savetxt(output_path, np.column_stack((x, smoothed)),delimiter=' ',fmt='%1.6f')
    print(f'      <-> module smoothing.py: Smoothed data saved as "smoothed_{path.basename(args.input_path)}"')



# >------------ execute ------------<
if __name__ == '__main__':
    main()