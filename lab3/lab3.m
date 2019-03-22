%% ENGR 451 - Lab 3
% Convolution, Part II

test_lab3; % initialize test_lab3 function

% Problems #1-4
x = ones(1, 15);
h = ones(1, 3);
for lc = 5:5:15
	test_lab3(x, h, lc);
end
test_lab3(x, h, 50);

% Problems #5-7
for lx = 14:16
	x = ones(1, lx);
	test_lab3(x, h, 15);
end

% Problem #8-9
test_lab3(1, 1, 1);
test_lab3(1, 1, 10);
 
% Problem #10-12
% load lab2 % assumes you have 'seashell.wav'in your directory
x = seashell(:)';
test_lab3(x, fir_lp, 100);
test_lab3(x, fir_lp, 200);
test_lab3(x, fir_hp, 100);

%% Program Listings
disp(' ')
disp('--- overlap_add.m --------------------------------')
type('overlap_add')
disp('--- overlap_save.m --------------------------------')
type('overlap_save')