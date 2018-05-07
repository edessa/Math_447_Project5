function [rgb_image, image_compressed, image_decompressed] = step_4(p)
rgb_image = (imread('doge.png'));
grey_image = double(rgb2gray(rgb_image));
Q = [16    11    10    16    24    40    51    61
    12    12    14    19    26    58    60    55
    14    13    16    24    40    57    69    56
    14    17    22    29    51    87    80    62
    18    22    37    56    68   109   103    77
    24    35    55    64    81   104   113    92
    49    64    78    87   103   121   120   101
    72    92    95    98   112   100   103    99]
image_compressed = zeros(size(rgb_image,1), size(rgb_image,2));
image_decompressed = zeros(size(rgb_image,1), size(rgb_image,2));

for x = 1: floor(size(rgb_image,1)/8)
	for y = 1: floor(size(rgb_image,2)/8)
		grey_block = grey_image((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y); %part A
		grey_block = grey_block - 128;
        
        [compressed, transform] = dct(grey_block);
		compressed = round(compressed./Q);

		dequant = compressed.*Q;
		decompressed = ((transform'*dequant*transform) + 128);

		image_compressed((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y) = compressed;
		image_decompressed((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y) = decompressed;
	end
end

imagesc(uint8(image_decompressed))
imagesc(uint8(image_compressed))
imagesc(rgb_image, [0 255])