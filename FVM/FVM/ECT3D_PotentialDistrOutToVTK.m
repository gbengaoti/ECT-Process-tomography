function ECT3D_PotentialDistrOutToVTK(filename,Vfr,vtx,simp,elecs,planes,elecgnd)
fid = fopen(filename,'w');
fprintf(fid,'# vtk DataFile Version 3.0\n');
fprintf(fid,'Rozklad pola elektrycznego 3D\n');
fprintf(fid,'ASCII\n');
fprintf(fid,'DATASET UNSTRUCTURED_GRID\n');
fprintf(fid,'POINTS %d float\n',size(vtx,1));
for i=1:size(vtx,1)
    fprintf(fid,'%6f %6f %6f\n',vtx(i,1),vtx(i,2),vtx(i,3));
end
fprintf(fid,'\nCELLS %d %d\n',size(simp,1),size(simp,1)*5);
for i=1:size(simp,1)
    fprintf(fid,'4 %d %d %d %d\n',simp(i,1)-1,simp(i,2)-1,simp(i,3)-1,simp(i,4)-1);
end
fprintf(fid,'\nCELL_TYPES %d\n',size(simp,1));
for i=1:size(simp,1)
    fprintf(fid,'10\n');
end
fprintf(fid,'\nPOINT_DATA %d\n',size(vtx,1));
elecs = size(Vfr,2);
for Comb=1:elecs
    fprintf(fid,'SCALARS Rozklad_dla_elektrody%d float\n',Comb);
    fprintf(fid,'LOOKUP_TABLE default\n');
    for i=1:size(Vfr,1)
        fprintf(fid,'%6f\n',Vfr(i,Comb));
    end
end
fclose(fid);

s1 = 'C:\MayaVi\mayavi.exe -d ';
s2 = filename;
s3 = ' -m BandedSurfaceMap';

comm = strcat(s1,s2,s3);
system(comm);

% %elektrody
% 
% elecsfid = fopen('c:\Vis\elecs.vtk','w');
% fprintf(elecsfid,'# vtk DataFile Version 3.0\n');
% fprintf(elecsfid,'Geometra_Elektrod 3D\n');
% fprintf(elecsfid,'ASCII\n');
% fprintf(elecsfid,'DATASET UNSTRUCTURED_GRID\n');
% 
% realsize = 0;
% newelec = [];
% index=1;
% 
% rows = size(elecgnd,1);
% allelecs = [];
% for i=1:rows
%     allelecs = horzcat(allelecs,elecgnd(i,:));
% end
% 
% fprintf(elecsfid,'POINTS %d float\n',size(vtx,1));
% for i=1:size(vtx,1)
%     fprintf(fid,'%6f %6f %6f\n',vtx(i,1),vtx(i,2),vtx(i,3));
% end
% 
% for i=1:3:size(allelecs,2)
%     if ((allelecs(i)~=0) && (allelecs(i+1)~=0) && (allelecs(i+2)~=0))
%         newelec(index) = allelecs(i);
%         newelec(index+1) = allelecs(i+1);
%         newelec(index+2) = allelecs(i+2);
%         index=index+3;      
%     end
% end
% 
% realsize = size(newelec,2);
% 
% fprintf(elecsfid,'\nCELLS %d %d\n',realsize/3,(realsize/3)*4);
% for i=1:3:realsize
%     if ((newelec(i)~=0) && (newelec(i+1)~=0) && (newelec(i+2)~=0))
%         fprintf(elecsfid,'3 %d %d %d\n',newelec(i)-1,newelec(i+1)-1,newelec(i+2)-1);
%     end
% end
% 
% fprintf(elecsfid,'\nCELL_TYPES %d\n',realsize/3);
% for i=1:realsize/3
%     fprintf(elecsfid,'5\n');
% end
% 
% fprintf(elecsfid,'\nPOINT_DATA %d\n',size(vtx,1));
% fprintf(elecsfid,'SCALARS Elektrody float\n');
% fprintf(elecsfid,'LOOKUP_TABLE ElectrodesColor\n');
% 
% for i=1:size(vtx,1)
%     if (~isempty(find(i==newelec)))
%         fprintf(fid,'1.0\n');
%     else
%         fprintf(fid,'0.0\n');
%     end
% end
% 
% fprintf(elecsfid,'LOOKUP_TABLE ElectrodesColor 2\n');
% fprintf(elecsfid,'0.0 0.0 0.0 0.0\n');
% fprintf(elecsfid,'0.0 1.0 0.0 0.5\n');
% 
% fclose(elecsfid);
