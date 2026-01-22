%% 一阶数字高通滤波器程序 (Fs=1000Hz, Fc=0.1Hz)
clear; clc; close all;

% --- 1. 参数设置 ---
fs = 1000;              % 采样频率 (Hz)
fc = 0.1;               % 截止频率 (Hz)

% --- 2. 滤波器设计 (使用双线性变换 butterworth) ---
% Wn 为归一化截止频率，计算公式: fc / (fs/2)
Wn = fc / (fs/2); 
[b, a] = butter(1, Wn, 'high');

% 打印系数查看 (可以看到 a1 非常接近 -1，这是超低频滤波器的特点)
disp('滤波器系数 b:'); disp(b);
disp('滤波器系数 a:'); disp(a);

% --- 3. 频率响应分析 ---
[h, f] = freqz(b, a, 1024*32, fs); % 使用较多点数以观察低频细节

figure('Color', 'w');
subplot(2,1,1);
semilogx(f, 20*log10(abs(h)), 'LineWidth', 1.5); % 使用对数坐标观察 0.1Hz
% 找到最接近 0.1Hz 的频率点索引
[~, idx] = min(abs(f - 0.1));
db_at_fc=20*log10(abs(h));
% 将 dB 转换为倍数
mag_at_fc = db2mag(db_at_fc); 
fprintf('在 %.1f Hz 处的增益为 %.4f dB，即幅值的 %.4f 倍\n', f(idx), db_at_fc, mag_at_fc);
% 理论上一阶滤波器在截止频率处应该是 -3.01 dB，即 0.707 倍grid on; hold on;
line([fc fc], [-60 0], 'Color', 'r', 'LineStyle', '--');
title(['一阶高通滤波器幅频响应 (Fc = ', num2str(fc), ' Hz)']);
ylabel('增益 (dB)'); xlabel('频率 (Hz)');
xlim([0.01 500]); % 聚焦低频段

subplot(2,1,2);
semilogx(f, angle(h)*180/pi, 'LineWidth', 1.5);
grid on;
ylabel('相位 (deg)'); xlabel('频率 (Hz)');
xlim([0.01 500]);

% --- 4. 时域信号处理演示 ---
t = 0:1/fs:1000;          % 生成 20 秒的信号
% 混合信号：0.02Hz 的基线漂移 (低频干扰) + 2Hz 的有用信号
drift = 0.5 * sin(2*pi*0.02*t);     % 待滤除的极低频
signal = 1.0 * sin(2*pi*0.12*t);       % 要保留的信号
signal_1 = 0.01 * sin(2*pi*10*t);       % 要保留的信号
x = drift + signal +signal_1;                 % 混合信号

% 执行滤波
% 注意：对于这种极低频滤波，filtfilt (零相位滤波) 通常比 filter 更好，
% 因为它不会产生相位漂移且能更好地处理起始段。
y = filtfilt(b, a, x); 

% --- 5. 绘图结果 ---
figure('Color', 'w');
subplot(2,1,1);
plot(t, x, 'Color', [0.7 0.7 0.7]); hold on;
plot(t, drift, 'r--', 'LineWidth', 1.2);
title('原始信号 (包含 0.02Hz 漂移 和 2Hz 信号)');
legend('混合信号', '0.02Hz 漂移成分');
grid on;

subplot(2,1,2);
plot(t, y, 'b', 'LineWidth', 1.2);
title('经 0.1Hz 高通滤波后的结果');
legend('处理后的信号 (2Hz)');
grid on;
xlabel('时间 (s)');