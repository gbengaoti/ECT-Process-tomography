% THIS IS THE CODE THAT GETS THE DISTANCE BETWEEN
% NEIGHBOURING TETRAHEDRONS AND SAVES FOR COMPUTATION
% IN THE FMV2 CODE

% INITIALIZATION
NoOfElectrodes = size(elecgnd,1);
NoOfNodes = size(vtx,1);
AllPhi = zeros(NoOfNodes,NoOfElectrodes);
AllDistance = cell(NoOfNodes);
AllVertexAttachements = cell(NoOfNodes,1);
TR = triangulation(simp,vtx(:,1),vtx(:,2),vtx(:,3));

% Find vertex attachements for each vertex
% Vertex attachments lets us know what tetrahedrons that belong to a 
% Particular control volume, every node is a control volume so we loop
% Through each node
for i =1:NoOfNodes
    ti = vertexAttachments(TR,i); % vertex attachements for i
    AllVertexAttachements(i) = vertexAttachments(TR,i);
    n = cellfun('length',ti);

    % to accurately calculate L we need to know neighbouring tetrahderons
    % we have vertex attachments of i, so we can store some information
    % about them in a cell array
    C = cell(n);
    tetNeighbour = 0;
    L = 0;
    % For each tetrahedron in the control volume of i
    % We store the tetrahedron NO, the nodes in the tetrahedron and the 
    % Edges in the control volume
    for g=1:n
        tetName = ti{1,1}(g);
        C{g,1} = ti{1,1}(g);
        C{g,2} = simp(tetName,:); 
        % save the edges as well
        allNodesInCV = C{g,2}(C{g,2}~= i);
        C{g,3} = [i,allNodesInCV(1)];
        C{g,4} = [i,allNodesInCV(2)];
        C{g,5} = [i,allNodesInCV(3)];
    end
    % Now for each tetrahedron we want to go through the edges and update A
    % Acccordingly
    for k = 1:n
        % go through edges for each tetrahedron
            for a = 3:5
                j = C{k,a}(2);                            
                AllDistance{i,(5*(k-1)+k)+(a-3)*2}= [i,j];
                % compare with other tetrahderons till you find neighbor
                % find neighboring tetrahderon -- by using intersection
                for u = 1:n
                    % We don't want an intersection between a tetrahedron 
                    % and itself
                    commonNodes = intersect(C{k,2},C{u,2});
                    % save all information for precomputation

                    if (length(commonNodes)) == 4
                        continue;
                    elseif (length(commonNodes) == 3) && (length(intersect(j,commonNodes)) == 1)
                        % true if we have 3 common nodes including j   
                        tetNeighbour = C{u,1};
                        % Now that we have tetNeighbour for j , we can calculate L
                        % neighbour
                        L = getDistance(tetNeighbour,C{k,1});
                        AllDistance{i,(5*(k-1)+k+1)+(a-3)*2} = L;
                        break
                    else
                        AllDistance{i,(5*(k-1)+k+1)+(a-3)*2} = 0;
                        continue;
                    end
                end

            end

    end
end