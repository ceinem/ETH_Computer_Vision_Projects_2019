function visualization_all_points(P)

IMG_NAME = 'images/image001.jpg';
figure();
img = imread(IMG_NAME);
image(img);
hold on;

% First Plane X-Z
for x = 0 : 7
    for z = 0 : 9
        point = [x; 0; z; 1];
        image_point = P * point;
        image_point = image_point/image_point(3);
        plot(image_point(1), image_point(2), 'g+', 'MarkerSize', 10)
    end
end

% Second Plane Y-Z
for y = 0 : 6
    for z = 0 : 9
        point = [0; y; z; 1];
        image_point = P * point;
        image_point = image_point/image_point(3);
        plot(image_point(1), image_point(2), 'g+', 'MarkerSize', 10)
    end
end



hold off;
end

