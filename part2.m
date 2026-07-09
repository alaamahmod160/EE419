% EE419 Comprehensive Assignment - Part 2
% Custom Code for Your Parameters: W = 3, Z = 9, Y = 5
clear; clc; close all;

%% 1. Parameter Definitions
A1 = 2.6;       % Message 1 Amplitude (V)
f1 = 4e3;       % Message 1 Frequency (Hz)
A2 = 3.7;       % Message 2 Amplitude (V)
f2 = 13e3;      % Message 2 Frequency (Hz)
Y = 5;          
fc = (50 + Y) * 1e3; % Your Carrier Frequency: 55 kHz

% Simulation settings
fs = 1e6;       % Sampling Frequency (1 MHz)
Ts = 1/fs;      
t = 0:Ts:2e-3;  % 2 ms window for clean frequency resolution

%% 2. Signal Generation
m = A1*cos(2*pi*f1*t) + A2*cos(2*pi*f2*t); % Multi-tone Message Signal
c = cos(2*pi*fc*t);                        % Carrier Wave

%% 3. Modulation Processing
% DSB-SC Modulation
s_dsb = m .* c; 

% Frequency Modulation (FM)
kf = 2*pi*1000;                   
inst_phase = kf * cumtrapz(t, m); 
s_fm = cos(2*pi*fc*t + inst_phase);

%% 4. FFT for DSB-SC Spectrum
N = length(t);
S_fft = fft(s_dsb)/N;           
S_shift = fftshift(S_fft);      
f = (-N/2:N/2-1)*(fs/N);        

%% 5. Plotting Panels
figure('Name', 'Part 2: Analog Modulation Systems', 'NumberTitle', 'off');

% Subplot 1: DSB-SC Time Domain
subplot(3,1,1);
plot(t*1e3, s_dsb, 'b', 'LineWidth', 1.2); hold on;
plot(t*1e3, m, 'r--', 'LineWidth', 1.1);  % Upper Envelope
plot(t*1e3, -m, 'r--', 'LineWidth', 1.1); % Lower Envelope
grid on;
title('DSB-SC Modulated Waveform s(t) with Message Envelope');
xlabel('Time (ms)'); ylabel('Amplitude (V)');
legend('DSB-SC Signal', 'Message Envelope');
xlim([0 2]);

% Subplot 2: DSB-SC Frequency Spectrum
subplot(3,1,2);
stem(f*1e-3, abs(S_shift), 'm.', 'LineWidth', 1.2);
grid on;
title('DSB-SC Two-Sided Magnitude Spectrum |S(f)|');
xlabel('Frequency (kHz)'); ylabel('|S(f)|');
xlim([25 85]); % Fits all 4 of your true sidebands perfectly
ylim([0 2]);

% Subplot 3: FM Time Domain
subplot(3,1,3);
plot(t*1e3, s_fm, 'k', 'LineWidth', 1.2);
grid on;
title('Frequency Modulated (FM) Waveform');
xlabel('Time (ms)'); ylabel('Amplitude (V)');
xlim([0 2]);