module toplevel(
    input clock_100m,       // 100MHz 时钟
    input enable,           // 使能
    input  [1:0] wave_word, // 波形控制字，00->正弦 01->三角 10->方波 11->PWM
    input [19:0] freq_word, // 频率控制字，fout = 100e6 / (2^28) * (2^freq_word)
    input  [6:0] pwm_word   // PWM 占空比控制字
);

endmodule