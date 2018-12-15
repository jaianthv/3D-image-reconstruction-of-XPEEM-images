Unx=double.empty();
Uny=double.empty();
Unz=double.empty();
MMx=double.empty();
MMy=double.empty();
MMz=double.empty();


%to extract for Paraview

for j=1:length(Mx(1,:))
    for i=1:length(Mx(:,1))
        ii=i-1; %for vtk
        jj=j-1; %for vtk
        Unx =  [Unx ii];  %x
        Uny =  [Uny jj];  %y
        Unz =  [Unz 0];  %z
        MMx = [MMx Mx(i,j)];
        MMy = [MMy My(i,j)];
        MMz = [MMz Mz(i,j)];


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

%baseFileName = sprintf('processedCut_%s.txt',x);
%imwrite(A{i,1},baseFileName);
%dlmwrite(baseFileName,cutX,'delimiter',' ','newline','pc');

fid = fopen('For_vtk_wholeimage.vtk','wt');
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
fprintf(fid,'SCALARS Something float\n');
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
