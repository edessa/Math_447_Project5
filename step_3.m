function [grey_image, image_compressed, image_decompressed] = step_3(p)
%function [rgb_image, compressed, decompressed, grey_block] = step_3(p)

rgb_image = (imread('doge.png'));
rgb_image = double(rgb_image);
grey_image = (0.2126*rgb_image(:,:,1) + 0.7152*rgb_image(:,:,2) + 0.0722*rgb_image(:,:,3));
Q = p * 8./hilb(8)
image_compressed = double(zeros(size(rgb_image,1), size(rgb_image,2)));
image_decompressed = double(zeros(size(rgb_image,1), size(rgb_image,2)));

for x = 1: floor(size(rgb_image,1)/8)
	for y = 1: floor(size(rgb_image,2)/8)
		grey_block = double(grey_image((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y)); %part A
      %  grey_block = grey_image(81 : 88, 81 : 88);

		grey_block = grey_block - 128;
    %    imagesc((grey_block));colormap(gray);

		[compressed, transform] = dct(grey_block);
        compressed = round(compressed./Q);
        imagesc(compressed);colormap(gray);

		dequant = compressed.*Q;
		decompressed = uint8((transform'*dequant*transform) + 128);

		image_compressed((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y) = compressed;
		image_decompressed((x-1)*8 + 1: 8*x, (y-1)*8 + 1: 8*y) = decompressed;
   		%image_compressed(81 : 88, 81 : 88) = compressed;
        %image_decompressed(81 : 88, 81 : 88) = decompressed;

	end
end

%imagesc(uint8(image_decompressed));colormap(gray)
%imagesc(uint8(image_compressed));colormap(gray)
