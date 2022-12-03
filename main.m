x = linspace(-2,2,1000);
y = linspace(-2,2,1000);
[X,Y] = meshgrid(x,y);
intensity = exp(-10 * ((X - 0.5).^2 + Y.^2) / 1^2);
figure
image(intensity,'CDataMapping','scaled')
colorbar
colormap(jet(4096))