prompt = {'Entre com a quantidade de kernels por classe'};
dlg_title = 'Input';
num_lines = 1;
def = {'3','hsv'};
K = inputdlg(prompt,dlg_title,num_lines,def);

K = str2num(cell2mat(K));
