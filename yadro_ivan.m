% Задание Yadro Impulse 2025, Вариант 3

close all;
clear all;
clc;

Fd = 100; %Частота дискретизации по условию
t = 0:1/Fd:1;
freqs = 0:1:50; %Частоты синуса

errors = zeros(size(freqs)); %Массив для ошибок для каждой частоты, изначально с нулями

for i = 1:length(freqs)
    f = freqs(i);
    x = sin(2 * pi * f * t);

    %Ручная децимация и интерполяция
    x_dec = decimate_manual(x);
    x_interp = interpolate_manual(x_dec);

    %Усечение до длины оригинала
    x_interp = x_interp(1:length(x));

    %Вычисление средней квадратической ошибки
    errors(i) = sqrt(mean((x - x_interp).^2));
end

%Построение графика ошибки
figure;
plot(freqs, errors, 'b.-');
xlabel('Частота синуса (Гц)');
ylabel('СКО ошибки');
title('Ошибка между оригиналом и сигналом после ручной децимации + интерполяции');
grid on;

%Функция децимации
function decm = decimate_manual(x)
    x_filt = zeros(1, length(x)); %Создаем массив с нулями

%Используем ФНЧ для сглаживания сигнала
    for i = 3:length(x)-2
        x_filt(i) = mean(x(i-2:i+2)); %В массив с нулями вписываем ср. из 5 точек (скользящего среднего)
    end

    decm = x_filt(1:2:end); %На выход функции берем каждую вторую точку 
end

%Функция ручной интерполяции
function intr = interpolate_manual(x)
    N = length(x);
    intr = zeros(1, 2 * N); %Создаем и заполняем 0 массив, в 2 раза больше исходного
    intr(1:2:end) = x; %Нечетным индексам присваиваем исходные значения

%Четным индексам присваиваем среднее между соседями
    for i = 2:2:(2*N - 2)
        intr(i) = (intr(i - 1) + intr(i + 1)) / 2;
    end
end
