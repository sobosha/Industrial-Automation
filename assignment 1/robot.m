trajectory = [ ...
    0   0     0;
    1   1     1;
    2   2.5   2;
    3   4     2.5;
    4   5.5   3.2;
    5   7     4;
    6   8     5.5;
    7   8.5   6.5;
    8   9     7;
    9   10    8 ];

x = trajectory(:,2);
y = trajectory(:,3);
t = trajectory(:,1);

x_ref = timeseries(x, t);
y_ref = timeseries(y, t);

x_real = out.X_out.Data;
y_real = out.y_out.Data;
t_real = out.X_out.Time;


figure;
scatter(x_real, y_real, 36, t_real, 'filled'); hold on;

plot(x, y, 'r--', 'LineWidth', 1.5);

plot(x, y, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'yellow', 'LineWidth', 1.2);

for i = 1:length(t)
    text(x(i) + 0.1, y(i) + 0.1, sprintf('t=%d', t(i)), 'FontSize', 9, 'Color', 'black');
end

colormap('jet');
colorbar;
xlabel('x'); ylabel('y');
title('Robot Trajectory vs. Reference Points');
legend('Robot Path (Real)', 'Reference Path', 'Trajectory Points');
grid on;
axis equal;
