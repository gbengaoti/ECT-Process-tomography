% THIS IS THE FVM CODE FOR ECT PROCESS TOMOGRAPHY
% AFTER CAREFUL DISCRETIZATION OF THE POISSION EQUATION
% WE OBTAIN A SYSTEM OF LINEAR EQUATIONS
% A\phi = b
% WHICH ARE SUBSEQUENTLY ASSEMBLED AS FOLLOWS
% A(i,i) = A(i,i) - \frac{L_L\epsilon(x_L)}{2L_{ij}}
% A(i,j) = A(i,j) + \frac{L_L\epsilon(x_L)}{2L_{ij}}
% b(i) = 5

% % Load the mesh
% load(matlab.mat);

% Because we have 32 electrodes, we need to assemble this equations for 
% each of them 

% INITIALIZATION
NoOfElectrodes = size(elecgnd,1);
NoOfNodes = size(vtx,1);
A = zeros(NoOfNodes,NoOfNodes);
b = zeros(NoOfNodes,1);
E = zeros(NoOfNodes,1);
AllPhi = zeros(NoOfNodes,NoOfElectrodes);
AllVertexAttachements = cell(NoOfNodes,1);

for elect = 1: NoOfElectrodes
    NodesElectrode1 = elecgnd(elect,:);
    NodesBeneathElectrode = NodesElectrode1(NodesElectrode1 ~= 0);
    excited = size(NodesBeneathElectrode,2);

    E(NodesBeneathElectrode,1) = 1;
    % Set Excitation voltage to 5 for nodes beneath an electrode
    b(NodesBeneathElectrode,1) = 5;
    
    TR = triangulation(simp,vtx(:,1),vtx(:,2),vtx(:,3));

    % Assemble the A matrix
    % Find vertex attachements for each vertex
    % Vertex attachments lets us know what tetrahedrons that belong to a 
    % Particular control volume, every node is a control volume so we loop
    % Through each node
    for i =1:NoOfNodes
        ti = vertexAttachments(TR,i); % vertex attachements for i
        AllVertexAttachements(i) = vertexAttachments(TR,i);
        n = cellfun('length',ti); 
        % Now for each tetrahedron we want to go through the edges and update A
        % Acccordingly
        for k = 1:n
            % go through edges for each tetrahedron
                for a = 3:5
                    edge = AllDistance{i,(5*(k-1)+k)+(a-3)*2};
                    j = edge(2);                    
                    L = AllDistance{i,(5*(k-1)+k+1)+(a-3)*2};
                    midE = (E(i) + E(j))/2;
                    % get length of edge(i,j)
                    % get coordinates for node i
                    coordsI = vtx(i,:);
                    coordsJ = vtx(j,:);
                    Lij = sqrt((coordsI(1,1)-coordsJ(1,1))^2 + (coordsI(1,2)-coordsJ(1,2))^2 + (coordsI(1,3)-coordsJ(1,3))^2);
                    A(i,i) = 0;
                    A(i,j) = A(i,j) + (L*midE *(0.5*Lij));                       
                 end
         end
    end
    phi = b\A;
    AllPhi(:,elect) = phi';
    % Empty variables for next electrode
    A = zeros(NoOfNodes,NoOfNodes);
    b = zeros(NoOfNodes,1);
    E = zeros(NoOfNodes,1);
end