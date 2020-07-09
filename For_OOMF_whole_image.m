Unx=double.empty();
Uny=double.empty();
Unz=double.empty();
MMx=double.empty();
MMy=double.empty();
MMz=double.empty();

% to extract for OOMF
for i=1:length(MX(:,1))
    for j=1:length(MX(1,:))
        Unx =  [Unx i];  %x
        Uny =  [Uny j];  %y
        Unz =  [Unz 0];  %z
        MMx = [MMx MX(i,j)];
        MMy = [MMy MY(i,j)];
        MMz = [MMz MZ(i,j)];
    end
end

Unx=transpose(Unx);
Uny=transpose(Uny);
Unz=transpose(Unz);
MMx=transpose(MMx);
MMy=transpose(MMy);
MMz=transpose(MMz);

cutX=double.empty();
cutX=[Unx Uny Unz MMx MMy MMz];

%x = erase(srcFiles(z).name,".tif");
%baseFileName = sprintf('processedCut_%s.txt',x);
%imwrite(A{i,1},baseFileName);
%dlmwrite(baseFileName,cutX,'delimiter',' ','newline','pc');


baseFileName1 = sprintf('ForOOMF_Whole image.svf');
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
clear MMx;
clear MMy;
clear MMz;
clear cutX;

