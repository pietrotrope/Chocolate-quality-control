load("boxClassifier");
load("chocolateClassifier");

%Il lavoro si è basato principalmente sulle foto fornite, usando FACTOR=8.
%Per foto in condizioni differenti non è garantito il funzionamento.

[result,errors] = isBoxValid(I,8,boxClassifier,chocolateClassifier);