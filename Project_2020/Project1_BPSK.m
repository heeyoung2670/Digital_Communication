clc; clear; close all;
%% Project1_BPSK
loaded_data = load('project1.mat');

% parameter setting for image
Height_ = loaded_data.Height;
Width_ = loaded_data.Width;
CH_ = loaded_data.CH;
Level_binary = loaded_data.Level_binary;
h = loaded_data.h; % Rayleigh fading 채널
y = loaded_data.y; % 수신 신호

% channel equalization
r = (conj(h)./abs(h).^2).*y;

% decoding
bit_stream_re_ = real(r)>0;

%% reconstruct image file
% construct bit matrix
image_bit_re_ = reshape(bit_stream_re_,[Height_*Width_*CH_,Level_binary]);

% binary to decimal
image_vec_re_ = bi2de(image_bit_re_);

% image file vector to matrix
image_re_ = uint8(reshape(image_vec_re_,[Height_,Width_,CH_]));

figure; imshow(image_re_)
