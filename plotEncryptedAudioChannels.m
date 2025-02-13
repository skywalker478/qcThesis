function plotEncryptedAudioChannels(filename)
    % Load the encrypted audio file
    fileID = fopen(filename, 'rb');
    if fileID == -1
        error('Failed to open file %s', filename);
    end

    nonce = fread(fileID, 12, '*uint8');  % Read and discard nonce
    encryptedAudio = fread(fileID, Inf, '*uint8');  % Read encrypted audio
    tag = fread(fileID, 16, '*uint8');  % Read and discard tag
    fclose(fileID);

    % Convert uint8 to int16 (assuming 16-bit signed integer)
    % We'll reshape it to have two columns for left and right channels
    numBytes = length(encryptedAudio);
    if mod(numBytes, 2) ~= 0
        encryptedAudio = encryptedAudio(1:end-1);  % Discard last byte if necessary
        warning('Discarded last byte of encrypted audio data');
    end

    numSamples = length(encryptedAudio) / 2;
    encryptedAudioInt16 = typecast(uint8(encryptedAudio), 'int16');
    leftChannel = encryptedAudioInt16(1:2:length(encryptedAudioInt16));
    rightChannel = encryptedAudioInt16(2:2:length(encryptedAudioInt16));
    
    maxVal = double(intmax('int16'));
    normalizedLeftChannel = double(leftChannel) / maxVal;
    normalizedRightChannel = double(rightChannel) / maxVal;

    % Plot the left and right channels separately
    figure;
    set(gca, 'FontSize', 8); % Set axis font size to 8 points
    set(gcf, 'DefaultAxesFontSize', 8);
    subplot(2,1,1);
    plot(normalizedLeftChannel);
    xlabel('Time (samples)');
    ylabel('Amplitude');
    title('Left Channel');
    ax=gca;
    xlim([0 length(normalizedLeftChannel)]);
    ylim([-1.1 1.1]);
    ax.YTick=[-1 0 1];

    subplot(2,1,2);
    plot(normalizedRightChannel,'r');
    xlabel('Time (samples)');
    ylabel('Amplitude');
    title('Right Channel');
    ax=gca;
    xlim([0 length(normalizedRightChannel)]);
    ylim([-1.1 1.1]);
    ax.YTick=[-1 0 1];
    
    tightfig;
    [~, name, ~] = fileparts(filename);
    print(gcf, '-painters', '-dsvg', [name '.svg']);
end