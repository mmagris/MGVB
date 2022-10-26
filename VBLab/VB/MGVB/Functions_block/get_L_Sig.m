function[L,iS] = get_L_Sig(S,setting)

% Takes S and returns iS (inverse of S) and the chol. factor of S (L)

% if size(S,1) == 1 && size(S,2) == 1
%     L = sqrt(S);
%     iS = 1/S;
% else

    if setting.UseInvChol == 0
        iS = inv(S);
        L = chol(S,'lower');
    elseif setting.UseInvChol == 1
        L = chol(S,'lower');
        iL = inv(L);
        iS = iL'*iL;
    end

% end

% UseInvChol == 0, inverts a the full matrix
% UseInvChol == 1, inverts a triangular matrix: less flops (but same
%                  complexity) of UseInvChol == 0,
%                  yet additional multiplication iL*iL'

% USAGE
% In experiments use UseInvChol == 1 is S is a "big matrix to invert"
% otherwise use UseInvChol == 0 (less operations and potentially more
% accurate results)

end
