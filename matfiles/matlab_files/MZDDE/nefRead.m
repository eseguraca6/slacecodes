% decode image data from Nikon .NEF file

function rgb = nefRead(fname)

[a,model]=rawCamFileRead(fname);
a=uint16(double(a)'/8);

switch lower(model)
    case 'd100'
	    % Bayer pattern for D100:
	    %       GBGBGB
	    %       RGRGRG
	    %       GBGBGB
		rgb(:,:,1)=a(1:2:end,2:2:end);
		rgb(:,:,2)=a(1:2:end,1:2:end);
		rgb(:,:,3)=a(2:2:end,1:2:end);
		rgb(:,:,4)=a(2:2:end,2:2:end);
    case 'd1'
	    % Bayer pattern for D1:  
	    %       BGBGBG
	    %       GRGRGR
	    %       BGBGBG
        rgb(:,:,1)=a(2:2:end,2:2:end);
        rgb(:,:,2)=a(1:2:end,2:2:end);
        rgb(:,:,3)=a(1:2:end,1:2:end);
        rgb(:,:,4)=a(2:2:end,1:2:end);
    case 'd70'
	    % Bayer pattern for D70:  
	    %       BGBGBG
	    %       GRGRGR
	    %       BGBGBG
        rgb(:,:,1)=a(2:2:end,2:2:end);
        rgb(:,:,2)=a(1:2:end,2:2:end);
        rgb(:,:,3)=a(1:2:end,1:2:end);
        rgb(:,:,4)=a(2:2:end,1:2:end);        
    otherwise
        disp('Unknown camera type');
end
