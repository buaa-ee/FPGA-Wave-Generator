module toplevel(
	input clk_50m,          // 50MHz 时钟
	input enable,           // 使能
	input  [1:0] wave_word, // 波形控制字，00->正弦 01->三角 10->方波 11->PWM
	input [19:0] freq_word, // 频率控制字，fout = 100e6 / (2^28) * (2^freq_word)
	input  [6:0] pwm_word,  // PWM 占空比控制字
	output da_clk,
	output [7:0] da_db
);

/*******************************/

wire clk_100m;

pll  pll_instance (
	.inclk0(clk_50m),
	.c0(clk_100m)
);

/*******************************/

wire [27:0] phase;

phase_adder  phase_adder_instance (
	.clock(clk_100m),
	.dataa({8'b0,freq_word}),
	.datab(phase),
	.result(phase)
);

/*******************************/

wire [7:0] sinewave;

rom_sin  rom_sin_instance (
	.address(phase[27:19]),
	.clock(clk_100m),
	.q(sinewave)
);

/*******************************/

waveform_controller  waveform_controller_instance (
	.enable(enable),
	.clk(clk_100m),
	.wave_word(wave_word),
	.pwm_word(pwm_word),
	.sinewave(sinewave),
	.address(phase[27:19]),
	.waveform(da_db)
);

assign da_clk = clk_100m;

endmodule
