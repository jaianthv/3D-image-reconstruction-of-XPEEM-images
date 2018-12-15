srcFiles = dir('I:\MEdynamics\Summary TaCoPt\corrected_13062018\xmcd_shifted\Cropped_for_Paper\TEST for SVG\C*');

for z =1 : length(srcFiles)

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


%to extract for Paraview

for j=1:length(cutMx(1,:))
    for i=1:length(cutMx(:,1))
        ii=i-1; %for vtk
        jj=j-1; %for vtk
        Unx =  [Unx ii];  %x
        Uny =  [Uny jj];  %y
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

baseFileName1 = sprintf('Forvtk_%s.vtk',x);
fid = fopen(baseFileName1,'wt');
fprintf(fid, '# vtk DataFile Version 3.0\n');
fprintf(fid, '# vtk from Matlab\n');
%fprintf(fid, 'Cube example\n');
fprintf(fid, 'ASCII\n');
fprintf(fid, 'DATASET STRUCTURED_GRID\n')
fprintf(fid, 'DIMENSIONS %d %d 1\n', length(cutMx(:,1)), length(cutMx(1,:)) );
%fprintf(fid, 'DATASET POLYDATA\n');
fprintf(fid, 'POINTS %d float\n', length(cutX(:,1)));

for i=1:length(cutX(:,1))
fprintf(fid,'%e %e %e \n ',cutX(i,1),cutX(i,2),cutX(i,3));
end
fprintf(fid, 'POINT_DATA %d\n', length(cutX(:,1)));
fprintf(fid, 'VECTORS velocity_vectors float\n');
for i=1:length(cutX(:,1))
fprintf(fid,'%f %f %f \n ',cutX(i,4),cutX(i,5),cutX(i,6));
end
%fprintf(fid,'SCALARS cell_scalars float 1\n')
%fprintf(fid,'POINT_DATA %f\n',length(cutX(:,1)) );
fprintf(fid,'SCALARS Mz float\n');
fprintf(fid,'LOOKUP_TABLE default\n');

% To get the scalar of Mx replace cutX(i,6) to cutX(i,4) and to get My replace cutX(i,6) with cutX(i,5)
for i=1:length(cutX)
    fprintf(fid,'%d\n',abs(cutX(i,6)));
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
