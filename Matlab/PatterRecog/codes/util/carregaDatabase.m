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
                      'Espondil�lise'
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
        case 'ocr'
            [ x , y ] = carregaDados( 11 , '../database/OCR/ocr.data',10);
        otherwise
    end
    
    if(length(features)==0)
        features = ones(length(y),10)*32;
        for i=1:length(y)
            txt = sprintf('feat %d',i);
            sz = length(txt);
            txt = char(padarray(double(txt),[0 10-sz],32,'pos'));
            features(i,:) = txt;
        end
    end

    if(exist('qtd'))
        [m n ] = size(x);
        I = randperm(m);
        I = I(1:qtd);
        x = x(I,:);
        y = y(I,:);
    end
    
end