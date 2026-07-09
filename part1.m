% EE419 Comprehensive Assignment - Part 1
% Student Parameter Setup: W = 3, Z = 9
clear; clc; close all;

%% 1. Parameter Definitions
A1 = 2.6;       % First Message Amplitude (V)
f1 = 4e3;       % First Message Frequency (Hz)
A2 = 3.7;       % Second Message Amplitude (V)
f2 = 13e3;      % Second Message Frequency (Hz)
fc = 501e3:

% Simulation settings for continuous-like execution
fs = 1e6;       % Sampling Frequency (1 MHz)
Ts = 1/fs;      % Sampling Period
t = 0:Ts:2e-3;  % Time vector from 0 to 2 ms

%% 2. Signal Generation
m = A1*cos(2*pi*f1*t) + A2*cos(2*pi*f2*t);

%% 3. Fast Fourier Transform (FFT) Setup
N = length(t);
M_fft = fft(m)/N;           % Normalized FFT
M_shift = fftshift(M_fft);  % Shift zero-frequency component to center
f = (-N/2:N/2-1)*(fs/N);    % Frequency vector

%% 4. Plotting Results
figure('Name', 'Part 1: Signal Analysis', 'NumberTitle', 'off');

% Subplot 1: Time Domain
subplot(2,1,1);
plot(t*1e3, m, 'b', 'LineWidth', 1.5);
grid on;
title('Personalized Message Signal');
xlabel('Time (ms)');
ylabel('Amplitude (V)');
xlim([0 2]);

% Subplot 2: Frequency Domain (Magnitude Spectrum)
subplot(2,1,2);
stem(f*1e-3, abs(M_shift), 'r.', 'LineWidth', 1.2);
grid on;
title('Two-Sided Magnitude Spectrum |M(f)|');
xlabel('Frequency (kHz)');
ylabel('|M(f)|');
xlim([-20 20]); % Focus on the relevant frequency range
ylim([0 2]);