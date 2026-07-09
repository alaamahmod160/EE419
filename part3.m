% EE419 Assignment 2 - Part 3: Digital Communication Subsystems
% Strict Implementation for Student Parameters: W = 3, Z = 9, Y = 5
clear; clc; close all;

%% 1. Parameter Definitions (Strictly Personalized)
A1 = 2.6; f1 = 4e3;    % Component 1 parameters
A2 = 3.7; f2 = 13e3;   % Component 2 parameters

% Analog continuous baseline duration (2 ms to show cycles clearly)
t_analog = 0:1e-6:2e-3; 
m_analog = A1*cos(2*pi*f1*t_analog) + A2*cos(2*pi*f2*t_analog);

% Computed Frequency Parameters
fN  = 26e3;            % Nyquist Rate (2 * 13 kHz)
fs1 = 31.2e3;          % Case I: Over-sampling frequency (1.2 * fN)
fs2 = 18.2e3;          % Case II: Under-sampling frequency (0.7 * fN)

%% 2. Sampling Implementation
% Case I: Over-sampling Execution
t_sample1 = 0:(1/fs1):2e-3;
m_sample1 = A1*cos(2*pi*f1*t_sample1) + A2*cos(2*pi*f2*t_sample1);

% Case II: Under-sampling Execution
t_sample2 = 0:(1/fs2):2e-3;
m_sample2 = A1*cos(2*pi*f1*t_sample2) + A2*cos(2*pi*f2*t_sample2);

%% 3. Uniform Mid-Rise Quantization (4-Bit Configuration)
n = 4;
L = 2^n;               % L = 16 Levels
Vmax = A1 + A2;        % Vmax = 6.3 V
Vmin = -Vmax;          % Vmin = -6.3 V
delta = (Vmax - Vmin) / L;  % delta = 0.7875 V

% Define codebook mid-points and decision partition boundaries explicitly
codebook = (Vmin + delta/2) : delta : (Vmax - delta/2);
partition = (Vmin + delta) : delta : (Vmax - delta);

% Quantize the Over-sampled Signal Vector
[index, m_quantized] = quantiz(m_sample1, partition, codebook);

%% 4. Precise SQNR Calculation Metrics
signal_power = mean(m_sample1.^2);
quantization_noise = m_sample1 - m_quantized;
noise_power = mean(quantization_noise.^2);

SQNR_theoretical = 6.02 * n + 1.76;
SQNR_experimental = 10 * log10(signal_power / noise_power);

% Print verified parameters directly to the command window
fprintf('====================================================\n');
fprintf('        VERIFIED PERSONALIZED RESULTS (W=3, Z=9)     \n');
fprintf('====================================================\n');
fprintf('Theoretical SQNR Baseline    : %.2f dB\n', SQNR_theoretical);
fprintf('Unique Experimental Simulated SQNR: %.2f dB\n\n', SQNR_experimental);

%% 5. PCM Coding Sequence Generation
% Map indices to true binary matrix layout (left-msb)
binary_matrix = de2bi(index, n, 'left-msb');

fprintf('====================================================\n');
fprintf('      FIRST 10 QUANTIZED SAMPLES & TRUE CODEWORDS    \n');
fprintf('====================================================\n');
disp('First Ten Quantized Voltages (V):');
disp(m_quantized(1:10).');
disp('Corresponding 4-bit Binary Codewords:');
disp(binary_matrix(1:10, :));

%% 6. Polar NRZ Line Coding Modulator Block
bitstream = reshape(binary_matrix.', 1, []); % Flatten matrix to stream
num_bits = length(bitstream);

% Map bits according to Polar NRZ: 1 -> +1V, 0 -> -1V
nrz_levels = zeros(1, num_bits);
for b = 1:num_bits
    if bitstream(b) == 1
        nrz_levels(b) = 1;
    else
        nrz_levels(b) = -1;
    end
end

% Construct time-axis sequence for plotting sharp steps without triangles
bit_duration = 1; 
t_nrz = [];
waveform_nrz = [];
for i = 1:num_bits
    t_nrz = [t_nrz, (i-1)*bit_duration, i*bit_duration];
    waveform_nrz = [waveform_nrz, nrz_levels(i), nrz_levels(i)];
end

%% 7. Data Visualization Plot Panels
% --- Figure 1: Discrete Sampling Verification ---
figure('Name', 'Part 3: Sampling Processing', 'NumberTitle', 'off');
subplot(2,1,1);
plot(t_analog*1e3, m_analog, 'k-', 'LineWidth', 1.2); hold on;
stem(t_sample1*1e3, m_sample1, 'b', 'LineWidth', 1.1, 'MarkerFaceColor','b');
grid on; xlim([0 2]); ylim([-7 7]);
title('Case I: Proper Over-sampling (fs1 = 31.2 kHz)');
xlabel('Time (ms)'); ylabel('Amplitude (V)');
legend('Analog Message', 'Discrete Samples');

subplot(2,1,2);
plot(t_analog*1e3, m_analog, 'k-', 'LineWidth', 1.2); hold on;
stem(t_sample2*1e3, m_sample2, 'r', 'LineWidth', 1.1, 'MarkerFaceColor','r');
grid on; xlim([0 2]); ylim([-7 7]);
title('Case II: Under-sampling / Aliasing Effect (fs2 = 18.2 kHz)');
xlabel('Time (ms)'); ylabel('Amplitude (V)');
legend('Analog Message', 'Corrupted Samples');

% --- Figure 2: Quantization Grid Response ---
figure('Name', 'Part 3: Quantization Staircase', 'NumberTitle', 'off');
plot(t_sample1*1e3, m_sample1, 'b--o', 'LineWidth', 1.0); hold on;
stairs(t_sample1*1e3, m_quantized, 'r', 'LineWidth', 1.5);
grid on; xlim([0 2]); ylim([-7 7]);
title('4-Bit Uniform Mid-Rise Quantizer Staircase Output');
xlabel('Time (ms)'); ylabel('Amplitude (V)');
legend('Sampled Vector', 'Quantized Staircase');

% --- Figure 3: Line Coding Stream ---
figure('Name', 'Part 3: Polar NRZ Waveform', 'NumberTitle', 'off');
plot(t_nrz, waveform_nrz, 'b', 'LineWidth', 1.8);
grid on; xlim([0 40]); ylim([-1.5 1.5]);
title('Polar Non-Return-to-Zero (NRZ) Encoded Signal');
xlabel('Bit Number'); ylabel('Amplitude (V)');