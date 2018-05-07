function [rgb_image, combined_compressed, combined_decompressed] = step_5(p)
rgb_image = (imread('doge.png'));
red = double(rgb_image(:,:,1));
green = double(rgb_image(:,:,2));
blue = double(rgb_image(:,:,3)); 
Q = p * 8./hilb(8);
red_compressed = zeros(size(rgb_image,1), size(rgb_image,2));
blue_compressed = zeros(size(rgb_image,1), size(rgb_image,2));
green_compressed = zeros(size(rgb_image,1), size(rgb_image,2));

red_decompressed = zeros(size(rgb_image,1), size(rgb_image,2));
green_decompressed = zeros(size(rgb_image,1), size(rgb_image,2));
blue_decompressed = zeros(size(rgb_image,1), size(rgb_image,2));

for x = 1: floor(size(rgb_image,1)/8)
	for y = 1: floor(size(rgb_image,2)/8)
		red_block = red((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y); %part A
        green_block = green((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y); %part A
		blue_block = blue((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y); %part A

		red_block = red_block - 128;
        green_block = green_block - 128;
		blue_block = blue_block - 128;
        
        [compressed_red, transform1] = dct(red_block);
        [compressed_green, transform2] = dct(green_block);
		[compressed_blue, transform3] = dct(blue_block);    

		compressed_red = round(compressed_red./Q);
		compressed_green = round(compressed_green./Q);
        compressed_blue = round(compressed_blue./Q);

		dequant_red = compressed_red.*Q;
		decompressed_red = ((transform1'*dequant_red*transform1) + 128);

		red_compressed((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y) = compressed_red;
		red_decompressed((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y) = decompressed_red;
        
        dequant_green = compressed_green.*Q;
		decompressed_green = ((transform2'*dequant_green*transform2) + 128);

		green_compressed((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y) = compressed_green;
		green_decompressed((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y) = decompressed_green;
        
        dequant_blue = compressed_blue.*Q;
		decompressed_blue = ((transform3'*dequant_blue*transform3) + 128);

		blue_compressed((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y) = compressed_blue;
		blue_decompressed((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y) = decompressed_blue;
	end
end

combined_compressed = cat(3, red_compressed, green_compressed, blue_compressed);
combined_decompressed = cat(3, red_decompressed, green_decompressed, blue_decompressed);
