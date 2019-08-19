function noisy_signal = add_gaussian_noise(signal,SNR);
%This function return a signal with additive Gaussian noise such that the
%Signal to Noise Ratio is equal to SNR
power_noise = 10*log10(rms(signal)^2)-SNR;
gaussian_noise = wgn(length(signal),1,power_noise);
noisy_signal = signal + gaussian_noise;