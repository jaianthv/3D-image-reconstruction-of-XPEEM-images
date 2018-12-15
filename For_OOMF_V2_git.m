srcFiles = dir('I:\MEdynamics\Summary TaCoPt\corrected_13062018\xmcd_shifted\Cropped_for_Paper\TEST for SVG\C*');

for z =1 : length(srcFiles)
 for z = 1:1
    Cut=imread(srcFiles(z).name); % if loading png convert it uint8
    %Cut=imread('center_cut.png');
    tempi=double.empty();
    tempj=double.empty();
    for i=1:398
        for j=1:398
            if Cut(i,j) == 1
               tempi = [tempi i];
               tempj = [tempj j];
            end
        end
     end
B=max(tempi)-min(tempi);
L=max(tempj)-min(tempj);
cutMx = imcrop(Mx,[min(tempi) min(tempj) B L]);
cutMy = imcrop(My,[min(tempi) min(tempj) B L]);
cutMz = imcrop(Mz,[min(tempi) min(tempj) B L]);

cutMx=flip(cutMx,2);
cutMy=flip(cutMy,2);
cutMz=flip(cutMz,2);

Unx=double.empty();
Uny=double.empty();
Unz=double.empty();
cutMMx=double.empty();
cutMMy=double.empty();
cutMMz=double.empty();

% to extract for OOMF
for i=1:length(cutMx(:,1))
    for j=1:length(cutMx(1,:))
        ii=i-1; %for vtk
        jj=j-1; %for vtk
        Unx =  [Unx i];  %x
        Uny =  [Uny j];  %y
        Unz =  [Unz 0];  %z
        cutMMx = [cutMMx cutMx(i,j)];
        cutMMy = [cutMMy cutMy(i,j)];
        cutMMz = [cutMMz cutMz(i,j)];


    end
end


Unx=transpose(Unx);
Uny=transpose(Uny);
Unz=transpose(Unz);
cutMMx=transpose(cutMMx);
cutMMy=transpose(cutMMy);
cutMMz=transpose(cutMMz);

cutX=double.empty();
cutX=[Unx Uny Unz cutMMx cutMMy cutMMz];

x = erase(srcFiles(z).name,".tif");

%baseFileName = sprintf('processedCut_%s.txt',x);
%imwrite(A{i,1},baseFileName);
%dlmwrite(baseFileName,cutX,'delimiter',' ','newline','pc');


baseFileName1 = sprintf('ForOOMF_%s.svf',x);
fid = fopen(baseFileName1,'wt');
fprintf(fid, '# OOMMF: irregular mesh v0.0\n');
fprintf(fid, '## File: sample.ovf\n');
fprintf(fid, '## Boundary-XY: 0 0 %d 0 %d %d 0 %d 0 0\n', i,i,j,j);
fprintf(fid, '## Grid step: 0 0.5 0\n');
for k=1:length(cutX)
fprintf(fid, '%d %d %d %d %d %d \n',cutX(k,1),cutX(k,2),cutX(k,3),cutX(k,4),cutX(k,5),cutX(k,6));
end
fclose(fid);

clear Unx;
clear Uny;
clear Unz;
clear cutMMx;
clear cutMMy;
clear cutMMz;
clear cutX;
clear tempi;
clear tempj;
clear Cut;


end
