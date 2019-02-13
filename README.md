# integratingSphere
For using integrating sphere data combined with gas exchange and fluorescence

### Purpose
This R package was written for use with Oceanview, which manages data collection for Ocean Optics spectroscopy products. In particular, this package is written for combining multiple datasets of transmission and reflection to get spectral absorbance by a leaf sample.
It contains a useful dataset for comparison with Li-6800 LEDs, which helps turn your absorbance measurements into absorbance values to plug in to electron transport measurements.

### Functions
***int_read***: reads in a tidy data frame from a single measurement from oceanview. Returns a table of the relevant measurement against wavelength.
***int_read_many***: Given a text check, reads in all matching files in a given folder and averages them. Returns a table of average readings versus wavelength.
***int_read_all***: Uses multiple calls of int_read_many to read in data from a folder of both reflectance and transmission data. Returns a table of Wavelength, Reflectance, Transmission, and Absorbance.
***int_graph***: Plots a reasonable graph of absorbance, reflectance, transmittance versus wavelength, with optional Li-6800 LED spectra added on. Useful if you wish to use the data from your spectra to influence your calculations of photosynthetic electron transport.
***int_baseline_all***: Works similarly to int_read_all %>% int_graph, but with an added correction. Provide a dataset of baseline reflectance to correct for incorrect measurements of reflectance due to reflectance off of the bottom of the integrating sphere. A relatively important correction at wavelengths where the leaf transmits a lot, especially far-red but also green wavelengths. Optionally write your data automatically to a csv.
***int_reconstitute***: If you're averaging a lot of measurements int_baseline_all runs relatively slowly. int_reconstitute uses the csv that int_baseline_all writes to functionally re-create the table and graph produced by int_baseline_all
