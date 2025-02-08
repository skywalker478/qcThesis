function plot_audio_channels(file_name)
%clear all
clc; close all;
% Read in the audio file
[audio, fs] = audioread(file_name);
% Separate the channels
left_channel = audio(:, 1);
right_channel = audio(:, 2);

% Plot both channels separately
figure;
set(gca, 'FontSize', 8); % Set axis font size to 8 points
set(gcf, 'DefaultAxesFontSize', 8);
subplot(2,1,1);
plot(left_channel);
xlabel('Time (samples)');
ylabel('Amplitude');
title('Left Channel');
ax=gca;
xlim([0 length(audio)]);
ylim([-1.1 1.1]);
ax.YTick=[-1 0 1];
subplot(2,1,2);
plot(right_channel,'r');
xlabel('Time (samples)');
ylabel('Amplitude');
title('Right Channel');
bx=gca;
xlim([0 length(audio)]);
ylim([-1.1 1.1]);
bx.YTick=[-1 0 1];
tightfig;
[~, name, ~] = fileparts(file_name);
print(gcf, '-painters', '-dsvg', [name '.svg']);
end