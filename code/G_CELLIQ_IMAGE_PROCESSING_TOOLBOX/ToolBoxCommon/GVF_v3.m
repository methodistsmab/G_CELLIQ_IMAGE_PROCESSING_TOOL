function [u,v] = GVF_v3(img, mu, ITER)

% path( '', path);
[m,n] = size(img);
H = fspecial('gaussian');
f = imfilter( img, H);
% fmin  = min(f(:));
% fmax  = max(f(:));
% f = (f-fmin)/(fmax-fmin);  % Normalize f to the range [0,1]
f = mat2gray( f);
f = BoundMirrorExpand(f);  % Take care of boundary condition
[fx,fy] = gradient(f);     % Calculate the gradient of the edge map
u = fx; v = fy;            % Initialize GVF to the gradient
SqrMagf = fx.*fx + fy.*fy; % Squared magnitude of the gradient field
q = double( SqrMagf > abs(eps));
% Iteratively solve for the GVF u,v
if ITER > 0    
    for i=1:ITER,
        u = BoundMirrorEnsure(u);
        v = BoundMirrorEnsure(v);
        u = u + mu*4*del2(u) - SqrMagf.*(u-fx);
        v = v + mu*4*del2(v) - SqrMagf.*(v-fy);
    end
end
u = BoundMirrorShrink(u);
v = BoundMirrorShrink(v);

Mag = sqrt( u.^2 + v.^2);
u = u./(Mag+abs(eps));
v = v./(Mag+abs(eps));

