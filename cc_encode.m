function c = cc_encode(u, trellis)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Cette fonction permet d'encoder un message bianire en suivant un trellis
% définit au préalable par poly2trellis
%
% INPUT
%   u: un vecteur de K symboles d'entrée
%   trellis: Une structure représentant le trellis
%
% OUTPUT    
%   c: Le message u encodé par le trellis
%
% EXEMPLE
%
% Inputs:
%   u = [1, 1, 0, 1, 0];
%   trellis = poly2trellis(3,[7,5],7);
% Ouput:
%   c = [1 1 1 0 0 0 1 0 0 0 1 0 1 1 1 1 0 1 0] 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Initialisation
    nb = log2(trellis.numInputSymbols);    % Nombre de bits par symbole d'entrée
    ns = log2(trellis.numOutputSymbols);   % Nombre de bits par symbole de sortie
    m = log2(trellis.numStates);           % Nombre de bits de mémoire
    K = length(u);                         % Longueur du message d'entrée
    L = K + m;                             % Longueur totale avec fermeture
    c = zeros(1, ns*L);                    % Vecteur de sortie codée

    % Colonnes pour l'entrée 0 et 1 de nextStates et outputs
    nextStates0 = trellis.nextStates(:,1); % États suivants pour l'entrée 0
    nextStates1 = trellis.nextStates(:,2); % États suivants pour l'entrée 1
    output0 = trellis.outputs(:,1);        % Sorties pour l'entrée 0
    output1 = trellis.outputs(:,2);        % Sorties pour l'entrée 1

    % État initial du codeur (état 0)
    currentState = 0;

    % Encodage de chaque bit d'entrée
    index = 1;  % Position pour stocker les bits de sortie dans c
    for bit = 1:K
        input = u(bit);  % Bit d'entrée actuel (0 ou 1)

        % Déterminer l'état suivant et la sortie en fonction de l'entrée
        if input == 0
            nextState = nextStates0(currentState + 1);  % État suivant pour l'entrée 0
            output = output0(currentState + 1);         % Sortie pour l'entrée 0
        else
            nextState = nextStates1(currentState + 1);  % État suivant pour l'entrée 1
            output = output1(currentState + 1);         % Sortie pour l'entrée 1
        end

        % Convertir la sortie en binaire et la stocker dans c
        binaryOutput = dec2bin(output, ns)-'0';  % Conversion en vecteur binaire de taille ns et en vecteur numérique (-'0')
        c(index:index+ns-1) = binaryOutput;        % Stockage dans c
        index = index + ns;

        % Mettre à jour l'état actuel
        currentState = nextState;
    end

    % Ajout des bits de terminaison pour fermer le treillis et ramener à l'état 0
    for bit = 1:m
        % Vérifie si l'entrée 0 ou 1 rapproche de l'état 0
        if nextStates0(currentState + 1) < nextStates1(currentState + 1)
            nextState = nextStates0(currentState + 1);
            output = output0(currentState + 1);
        else
            nextState = nextStates1(currentState + 1);
            output = output1(currentState + 1);
        end

        % Convertir la sortie en binaire et la stocker dans c
        binaryOutput = dec2bin(output, ns) - '0';
        c(index:index+ns-1) = binaryOutput;
        index = index + ns;

        % Mettre à jour l'état actuel
        currentState = nextState;

        % Vérifier si nous sommes de retour à l'état 0
        if currentState == 0
            break;
        end
    end
end
