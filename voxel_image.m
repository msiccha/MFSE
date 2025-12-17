function [vert, fac] = voxel_image( pts, vox_sz, color, alpha, edgec )
%VOXEL_IMAGE Creates a 3D voxel image
%   Parameters:
%   pts    - n x 3 matrix with 3D points
%   vox_sz - 1 x 3 vector with voxel size - if vox_sz is a scalar, all
%            edges will have the same length
%   color  - face color
%   alpha  - face alpha (opacity)
%   edgec  - edge color
%
%   Return values:
%   vert   - 8n x 3 matrix containing the vertices of the voxels
%   fac    - 6n x 4 matrixes containing the indexes of vert that form a
%            face
% Example:
%
% pts = [1,1,1; 2,2,2];
% vs = [0.5, 0.5, 0.5];
% voxel_image(pts, vs);
% view([-37.5, 30]);
%
% This example creates two voxels (at (1,1,1) and (2,2,2)) with edges of
% length 0.5
%
% Author: Stefan Schalk, 11 Feb 2011
% Copyright (c) 2011, Stefan
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

if (nargin < 1)
    error('No input arguments given');
end
if (nargin < 2)
    vox_sz = [1,1,1];
end
if (nargin < 3)
    color = 'b';
end
if (nargin < 4)
    alpha = 1;
end
if (nargin < 5)
    edgec = 'k';
end
if (size(pts,2) ~= 3)
    error('pts should be an n x 3 matrix');
end
if (isscalar(vox_sz))
    vox_sz = vox_sz*ones(1,3);
end
if (size(vox_sz,1) ~= 1 || size(vox_sz,2) ~= 3)
    error('vox_sz should be an 1 x 3 vector');
end
np = size(pts,1);
vert = zeros(8*np,3);
fac = zeros(6*np,4,'uint32');
vert_bas = [...
        -0.5,-0.5,-0.5;
        0.5,-0.5,-0.5;
        0.5,0.5,-0.5;
        -0.5,0.5,-0.5;
        -0.5,-0.5,0.5;
        0.5,-0.5,0.5;
        0.5,0.5,0.5;
        -0.5,0.5,0.5];
vert_bas = vert_bas.*([vox_sz(1).*ones(8,1), vox_sz(2).*ones(8,1), vox_sz(3).*ones(8,1)]);
fac_bas = [...
        1,2,3,4;
        1,2,6,5;
        2,3,7,6;
        3,4,8,7;
        4,1,5,8;
        5,6,7,8];
for vx = 1:np
    a = ((vx-1)*8+1):vx*8;
    for dim = 1:3
        vert( a,dim ) = vert_bas(:,dim) + pts(vx,dim);
    end
    fac ( ((vx-1)*6+1):vx*6,: ) = (vx - 1)*8*ones(6,4) + fac_bas;
end
patch('Vertices',vert,'Faces',fac,'FaceColor',color,'FaceAlpha',alpha,'Edgecolor',edgec);
end
