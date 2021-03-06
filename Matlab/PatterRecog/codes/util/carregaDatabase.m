function [x y labels features] = carregaDatabase(name,qtd)

    features = [];
    switch name
        case 'iris'
            [ x , y ] = carregaDados( 4 , '../database/iris/bezdekIris.data',3);
            labels = [ 'setosa    '
                       'versicolor'
                       'virginica '];
            features = ['sepal length'
                        'sepal width '
                        'petal length'
                        'petal width '];
        case 'vertebra'
            [ x , y ] = carregaDados( 4 , '../database/verte/column_3C.dat',3);
            labels = ['Hernia discal'
                      'Espondilolise'
                      'Normal       '];
        case 'derme'
            [ x , y ] = carregaDados( 7 , '../database/dermat/dermatology.data',6);
            labels =      [ 'psoriasis               '
                            'seboreic dermatitis     '
                            'lichen planus           '
                            'pityriasis rosea        '
                            'cronic dermatitis       '
                            'pityriasis rubra pilaris'
                         ];
                     
             labels =      [ 'psoriasis'
                             'seboreic '
                             'l. planus'
                             'pit rosea'
                             'c. dermat'
                             'pit rubra'
                         ];
                     
                     
         case 'breastC'          
            [ x , y ] = carregaDados( 3 , '../database/breastCancer/bc.txt',2);
            labels =      [ 'malignant'
                            'benign   '
                         ];
                     
             features =      [ 'Clump Thickness             '
                               'Uniformity of Cell Size     '
                               'Uniformity of Cell Shape    '
                               'Marginal Adhesion           '
                               'Single Epithelial Cell Size '
                               'Bare Nuclei                 '
                               'Bland Chromatin             '
                               'Normal Nucleoli             '
                               'Mitoses                     '
                         ];                     

        case 'haber'          
            [ x , y ] = carregaDados( 3 , '../database/haberman/hab.txt',2);
            labels =      [ 'Sobreviveu'
                            'Faleceu   '
                         ];
                     
             features =      [ 'Idade        '
                               'Ano operacao '
                               'n nodulos    '
                         ];                        

        
        case 'diab'          
            [ x , y ] = carregaDados( 3 , '../database/diabetes/dia.txt',2);
            labels =      [ '1'
                            '2'
                         ];
                     
             features =      [ 'n gravidez   '
                               'plasm concent'
                               'pressao Dias '
                               'tric tick    '
                               'insulim 2h   '
                               'IMC          '
                               'ped func     '
                               'idade        '
                         ]; 
                     
                     
        case 'ocr'
            [ x , y ] = carregaDados( 11 , '../database/OCR/ocr.data',10);
        otherwise
    end
    
    if(length(features)==0)
        features = ones(length(x(1,:)),10)*32;
        for i=1:length(x(1,:))
            txt = sprintf('feat %d',i);
            sz = length(txt);
            txt = char(padarray(double(txt),[0 10-sz],32,'pos'));
            features(i,:) = txt;
        end
        features  = char(features);
    end

    if(exist('qtd'))
        [m n ] = size(x);
        I = randperm(m);
        I = I(1:qtd);
        x = x(I,:);
        y = y(I,:);
    end
    
    fprintf('Carregando base %s\n',name);
    fprintf('Número de atributos da base %d \n',size(x,2));
    fprintf('Número de classes: %d \n',size(y,2));
    fprintf('Classes:\n');
%     disp(labels);
%     disp(features);
    
end