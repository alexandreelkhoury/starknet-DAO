Description de l'Approche :

1- Initialisation de la Proposition : Le contrat démarre par l'initialisation d'une proposition sur laquelle les électeurs peuvent voter. La proposition est stockée dans le champ proposal de la structure de stockage.

2- Processus de Vote : Les électeurs peuvent exprimer leur vote en faveur ou contre la proposition. Lorsqu'un électeur vote, le contrat vérifie d'abord si l'électeur a déjà voté en consultant le mapping hasVoted. Ensuite il vérifie si la période de vote est toujours en cours. Si l'électeur n'a pas déjà voté, son vote est enregistré dans le mapping hasVoted avec la valeur true. Le nombre total de votes pour et contre est suivi à l'aide des champs votedFor et votedAgainst.

3- Comptage des Votes et annonce du Résultat: Une fonction est disponible pour compter le nombre total de votes pour et contre. Seul l'administrateur du contrat peut appeler cette fonction.Si le nombre de votes pour est supérieur ou égal au nombre de votes contre, la proposition est acceptée. Sinon, la proposition est refusée. Le résultat est émis sous forme d'événement et également retourné comme résultat de la fonction.

C'est la manière la plus simple et la moins chère en gas je trouve. Il est possible de faire plus complexe en utilisant des structures de données pour le suivi du vote de chaque address, mais cela coûtera plus cher en gas.
