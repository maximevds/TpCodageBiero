function c = cc_encode(u, trellis)
%---------------------------------------------------------
% cc_encode : Encodeur convolutif
% Entrées :
%   u        : vecteur binaire du message [1 x K]
%   trellis  : structure du code convolutif (poly2trellis)
% Sortie :
%   c        : mot de code binaire [1 x ns*L]
%---------------------------------------------------------

m = log2(trellis.numStates);    % profondeur mémoire
ns = log2(trellis.numOutputSymbols); % nb de bits de sortie
%K = length(u);                  % longueur du message

% fermeture du treillis -> on ajoute m bits à zéro
u = [u zeros(1, m)];
L = length(u);                  % longueur totale avec fermeture

% Initialisation
state = 0;                      % état initial = 0
c = zeros(1, ns * L);           %vecteur de sortie

% Boucle principale d'encodage
for i = 1:L
    input = u(i);                                   % bit d'entrée
    output = trellis.outputs(state+1, input+1);     % sortie en décimal
    output_bits = de2bi(output, ns, 'left-msb');    % conversion binaire
    c((i-1)*ns + 1 : i*ns) = output_bits;           % ajout à la sortie
    state = trellis.nextStates(state+1, input+1);   % maj état
end

end
