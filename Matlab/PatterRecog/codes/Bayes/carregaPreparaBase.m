%Configurações
opc = {'iris','vertebra','derme'};
nomeBases = {'Íris','Vertebra','Dermatologia'};
[s,v] = listdlg('PromptString','Selecione uma base de dados:','SelectionMode','single','ListString',opc)
if(~v) return;end;

base = cell2mat(opc(s));     %Nome da base
baseSelecionada = cell2mat(nomeBases(s));

[ x , y ,labels, features ] = carregaDatabase(base);


%Selecionando caracteristicas
opc = mat2cell(features, ones(1, length(features(:,1))));
[p,v] = listdlg('PromptString','Selecione uma base de dados:','SelectionMode','multiple','ListString',opc)
if(~v || length(p)<2) 
      return;
end;



%Filtrar colunas desejadas e resolver problema das linhas duplicadas
x = x(:,p);

[x ia] = unique(x,'rows');
y = y(ia,:);

%Normalizando
%x = bsxfun(@minus,x,min(x));
%x = bsxfun(@rdivide,x,max(x));


[m n] = size(x);
[m nClasses] = size(y);