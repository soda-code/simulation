% 1. 参数定义
fs = 1000;              % 采样频率 (Hz)
t = 0:1/fs:1000;           % 时间向量 (1秒)
fc = 0.1;                % 截止频率 (50Hz)

% 2. 生成信号
% 低频干扰信号 (例如 5Hz 的基线漂移)
low_freq_noise = 2 * sin(2*pi*0.5*t); 
% 高频有用信号 (例如 150Hz 的正弦波)
high_freq_signal =3 * sin(2*pi*0.01*t); 
% 混合信号
x = low_freq_noise + high_freq_signal;

% 3. 设计并应用二阶高通滤波器
[b, a] = butter(2, fc/(fs/2), 'high');
y = filter(b, a, x);

% 4. 绘图展示
figure('Color', 'w', 'Position', [100, 100, 900, 600]);

% --- 滤波前后的数据对比 ---
subplot(2,1,1);
plot(t, x, 'Color', [0.7 0.7 0.7], 'LineWidth', 1, 'DisplayName', '滤波前 (信号 + 5Hz漂移)');
hold on;
plot(t, y, 'Color', [0 0.4470 0.7410], 'LineWidth', 1.5, 'DisplayName', '滤波后 (保留高频)');
grid on;
legend('Location', 'northeast');
title('二阶高通滤波：时域信号对比');
xlabel('时间 (s)');
ylabel('幅度');

% 标注效果
text(0.1, 2.5, '\leftarrow 这里的巨大起伏被滤除了', 'FontSize', 10, 'Color', 'r');

% --- 频率响应标注 (回顾) ---
subplot(2,1,2);
[h, f] = freqz(b, a, 1024, fs);
mag = 20*log10(abs(h));
semilogx(f, mag, 'LineWidth', 1.5);
hold on; grid on;

% 标注截止频率
plot(fc, -3, 'ro', 'MarkerFaceColor', 'r');
text(fc*1.1, -5, ['截止频率 f_c = ', num2str(fc), 'Hz'], 'Color', 'r');
% 标注斜率区
f_slope = [fc/10, fc/5];
text(f_slope(1), -35, '+40 dB/dec \rightarrow', 'FontWeight', 'bold');

title('对应的滤波器幅频特性');
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');