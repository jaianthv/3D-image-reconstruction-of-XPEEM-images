%incident angle of X-ray in degrees
IX = 16;
%Relative sample position with respect to X-ray
%Angle of image 1
I_one = 0;
%Angle of image 2
I_two = 45;
%Angle of image 3
I_three = 90;
%%%%%%%%%%%%%%%%%%%%%%%%%
I_0=imread('0.tif');
I_45=imread('45.tif');
I_90=imread('90.tif');
%I_180=imread('180deg_20FOV.tif');

I_0=double(I_0);
I_45=double(I_45);
I_90=double(I_90);
%I_180=double(I_180);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5


A = cell(length(I_0(1,:)),length(I_0(:,1)));

for i=1:length(I_0(1,:))
    for j = 1:length(I_0(:,1))
        A{i,j}={I_0(i,j)+0.395 I_45(i,j) I_90(i,j)};
    end
end


a=[ cosd(IX)*cosd(I_one) cosd(IX)*cosd(90-I_one) sind(IX)
    cosd(IX)*cosd(I_two) cosd(IX)*cosd(90-I_two) sind(IX)
    cosd(IX)*cosd(I_three) cosd(IX)*cosd(90-I_three) sind(IX)];

%a=[ cosd(16) 0 sind(16);
%    cosd(16)*cosd(45) cosd(16)*sind(45) sind(16);
%    0 cosd(16) sind(16)];

X=double.empty();
MX=double.empty();
MY=double.empty();
MZ=double.empty();


for i=1:length(I_0(1,:))
    for j = 1:length(I_0(:,1))

        B = cell2mat(A{i,j});
        B = B';
        X = linsolve(a,B);
        MX(i,j) = X(1);
        MY(i,j) = X(2);
        MZ(i,j) = X(3);

    end
 end

 imwrite(MX,'Mx.tif');
 imwrite(MY,'My.tif');
 imwrite(MZ,'Mz.tif');


 dlmwrite('vectorMx.txt',MX,'delimiter',' ','newline','pc');
 dlmwrite('vectorMy.txt',MY,'delimiter',' ','newline','pc');
 dlmwrite('vectorMz.txt',MZ,'delimiter',' ','newline','pc');



%%%%%%%%%%%%%%%%%%%%%
