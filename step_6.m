function [rgb_image, combined_compressed, combined_decompressed] = step_6(p)
rgb_image = (imread('doge.png'));
red = double(rgb_image(:,:,1));
green = double(rgb_image(:,:,2));
blue = double(rgb_image(:,:,3)); 

Y = 0.299*red + 0.587*green + 0.114*blue;
U = blue - Y;
V = red - Y;

Q = p * 8./hilb(8);
Y_compressed = zeros(size(rgb_image,1), size(rgb_image,2));
U_compressed = zeros(size(rgb_image,1), size(rgb_image,2));
V_compressed = zeros(size(rgb_image,1), size(rgb_image,2));

Y_decompressed = zeros(size(rgb_image,1), size(rgb_image,2));
U_decompressed = zeros(size(rgb_image,1), size(rgb_image,2));
V_decompressed = zeros(size(rgb_image,1), size(rgb_image,2));

for x = 1: floor(size(rgb_image,1)/8)
	for y = 1: floor(size(rgb_image,2)/8)
		Y_block = Y((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y); %part A
        V_block = V((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y); %part A
		U_block = U((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y); %part A

        Y_block = Y_block - 128;
        V_block = V_block - 128;
		U_block = U_block - 128;
        
        [compressed_Y, transform1] = dct(Y_block);
        [compressed_V, transform2] = dct(V_block);
		[compressed_U, transform3] = dct(U_block);  

		compressed_Y = round(compressed_Y./Q);
        compressed_V = round(compressed_V./Q);
		compressed_U = round(compressed_U./Q);

		dequant_Y = compressed_Y.*Q;
		decompressed_Y = ((transform1'*dequant_Y*transform1) + 128);

		Y_compressed((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y) = compressed_Y;
		Y_decompressed((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y) = decompressed_Y;
        
        dequant_V = compressed_V.*Q;
		decompressed_V = ((transform2'*dequant_V*transform2) + 128);

		V_compressed((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y) = compressed_V;
		V_decompressed((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y) = decompressed_V;
        
        dequant_U = compressed_U.*Q;
		decompressed_U = ((transform3'*dequant_U*transform3) + 128);

		U_compressed((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y) = compressed_U;
		U_decompressed((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y) = decompressed_U;
	end
end

blue_comp = U_compressed + Y_compressed;
red_comp = V_compressed + Y_compressed;
green_comp = (Y_compressed - 0.299*red_comp - 0.114*blue_comp)/(0.587)

blue_decomp = U_decompressed + Y_decompressed;
red_decomp = V_decompressed + Y_decompressed;
green_decomp = (Y_decompressed - 0.299*red_decomp - 0.114*blue_decomp)/(0.587)

combined_compressed = cat(3, red_comp, green_comp, blue_comp);
combined_decompressed = cat(3, red_decomp, green_decomp, blue_decomp);
