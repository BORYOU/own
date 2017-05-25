%%%% Initialize %%%%%
pic_filename = 'Orl';
% pic_filename = 'Orl_shelter';  % if getting sOrl picture, uncomment this line,
% comment the upper line
cow_choose = 4;   % choose the picture to show
picture_save_format = '.eps'; % format of picture to save 

%%%% Main %%%%%
load([pic_filename,'.mat']);
row_num = 112;  % row size of the picture
cow_num = 92;  % cow size of the picture

pic = reshape(A(:,cow_choose), row_num, cow_num);
picdc = zeros(row_num,cow_num-1);
picdr = zeros(row_num-1,cow_num);

% left column minus right column
for i = 1:cow_num-1
    picdc(:,i) = pic(:,i) - pic(:,i+1);
end

% upper row minus lower row
for i = 1:row_num-1
    picdr(i,:) = pic(i,:) - pic(i+1,:);
end

% plot picture
figure
initialpic = imagesc(pic);
colormap(gray(256));
initial_pic_filename = [pic_filename, '_', int2str(cow_choose), '_inital', picture_save_format];
saveas(initialpic,initial_pic_filename);
title('initial picture');

hold on
figure
left_right_pic = imagesc(picdc);
colormap(gray(256))
left_right_pic_filename = [pic_filename, '_', int2str(cow_choose), '_left_right', picture_save_format];
saveas(left_right_pic,left_right_pic_filename);
title('left\_right picture');

hold on
figure
upper_lower_pic = imagesc(picdr);
colormap(gray(256))
upper_lower_pic_filename = [pic_filename, '_', int2str(cow_choose), '_upper_lower', picture_save_format];
saveas(upper_lower_pic,upper_lower_pic_filename);
title('upper\_lower picture');