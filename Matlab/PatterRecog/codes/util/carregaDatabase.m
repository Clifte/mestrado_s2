function [x y labels] = carregaDatabase(name)

    switch name
        case 'iris'
            [ x , y ] = carregaDados( 4 , '../database/iris/bezdekIris.data',3);
            labels = [ 'setosa    '
                            'versicolor'
                            'virginica '];
        case 'vertebra'
            [ x , y ] = carregaDados( 4 , '../database/verte/column_3C.dat',3);
            labels = ['Hernia discal'
                           'Espondilólise'
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

end