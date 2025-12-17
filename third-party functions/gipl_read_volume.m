function [V] = gipl_read_volume(info)
% function for reading volume of Guys Image Processing Lab (Gipl) volume file
% 
% volume = gipl_read_header(file-header)
%
% examples:
% 1: info = gipl_read_header()
%    V = gipl_read_volume(info);
%    imshow(squeeze(V(:,:,round(end/2))),[]);
%
% 2: V = gipl_read_volume('test.gipl');
% Copyright (c) 2009, Dirk-Jan Kroon
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

if(~isstruct(info)) info=gipl_read_header(info); end

% Open gipl file
f=fopen(getfield(info,'filename'),'rb','ieee-be');

  % Seek volume data start
  if(info.image_type==1), voxelbits=1; end
  if(info.image_type==7||info.image_type==8), voxelbits=8; end
  if(info.image_type==15||info.image_type==16), voxelbits=16; end
  if(info.image_type==31||info.image_type==32||info.image_type==64), voxelbits=32; end
  if(info.image_type==65), voxelbits=64; end
  
  datasize=prod(getfield(info,'sizes'))*(voxelbits/8);
  fsize=getfield(info,'filesize');
  fseek(f,fsize-datasize,'bof');

  % Read Volume data
  volsize(1:3)=getfield(info,'sizes');

  if(info.image_type==1), V = logical(fread(f,datasize,'bit1')); end
  if(info.image_type==7), V = int8(fread(f,datasize,'char')); end
  if(info.image_type==8), V = uint8(fread(f,datasize,'uchar')); end
  if(info.image_type==15), V = int16(fread(f,datasize,'short')); end 
  if(info.image_type==16), V = uint16(fread(f,datasize,'ushort')); end
  if(info.image_type==31), V = uint32(fread(f,datasize,'uint')); end
  if(info.image_type==32), V = int32(fread(f,datasize,'int')); end
  if(info.image_type==64), V = single(fread(f,datasize,'float')); end 
  if(info.image_type==65), V = double(fread(f,datasize,'double')); end 

fclose(f);

% Reshape the volume data to the right dimensions
V = reshape(V,volsize);

