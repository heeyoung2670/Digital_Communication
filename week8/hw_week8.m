clc; clear; close all;
%% homework_week8
loaded_data = load('homework.mat');

% parameter setting for image
Height_ = loaded_data.Height_;
Width_ = loaded_data.Width_;
CH_ = loaded_data.CH_;
Level_binary = loaded_data.Level_binary;
h = loaded_data.h; % Rayleigh fading 채널
y1 = loaded_data.y1; % 수신 신호1
y2 = loaded_data.y2; % 수신 신호2
y3 = loaded_data.y3; % 수신 신호3

% channel equalization
r1 = (conj(h)./abs(h).^2).*y1;
r2 = (conj(h)./abs(h).^2).*y2;
r3 = (conj(h)./abs(h).^2).*y3;

% decoding
bit_stream_re_1 = real(r1)>0;
bit_stream_re_2 = real(r2)>0;
bit_stream_re_3 = real(r3)>0;

%% reconstruct image file
% construct bit matrix
image_bit_re_1 = reshape(bit_stream_re_1,[Height_*Width_*CH_,Level_binary]);
image_bit_re_2 = reshape(bit_stream_re_2,[Height_*Width_*CH_,Level_binary]);
image_bit_re_3 = reshape(bit_stream_re_3,[Height_*Width_*CH_,Level_binary]);

% binary to decimal
image_vec_re_1 = bi2de(image_bit_re_1);
image_vec_re_2 = bi2de(image_bit_re_2);
image_vec_re_3 = bi2de(image_bit_re_3);

% image file vector to matrix
image_re_1 = uint8(reshape(image_vec_re_1,[Height_,Width_,CH_]));
image_re_2 = uint8(reshape(image_vec_re_2,[Height_,Width_,CH_]));
image_re_3 = uint8(reshape(image_vec_re_3,[Height_,Width_,CH_]));

figure(1); imshow(image_re_1)
figure(2); imshow(image_re_2)
figure(3); imshow(image_re_3)
