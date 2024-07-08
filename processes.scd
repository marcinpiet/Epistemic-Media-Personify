/////////////////////////////////////////////////////////////////////////////
//individual code goes below

//fft scrambler
(
Ndef(\fftBinScrambler, {
	arg rate=1, wipe = 0, width = 1, pulseRate =1, volMax = 1, pan = 0;
	var bufferRead = PlayBuf.ar(1, ~buffer, rate, loop: 1);
	var pulse = Impulse.ar(pulseRate);
	var chain = FFT(LocalBuf(2048), bufferRead);
	// moves in and out of freeze
	chain = PV_BinScramble(chain, wipe, width, pulse);

	Pan2.ar((volMax * IFFT(chain)), pan);

});
//generate a graphic interface with parameters specs
//Ndef(\fftBinScrambler).gui;
Ndef(\fftBinScrambler).addSpec(\wipe, [0, 1, \lin]);
Ndef(\fftBinScrambler).addSpec(\width, [0, 1, \lin]);
Ndef(\fftBinScrambler).addSpec(\pulseRate, [1, 1000, \lin]);
Ndef(\fftBinScrambler).addSpec(\volMax, [0.5, 5, \lin]);
);

(
Ndef(\fftMagnitudesSmear, {
	arg rate=1, smear = 1, volMax = 1;
	var bufferRead = PlayBuf.ar(1, ~buffer, rate, loop: 1);
	var chain = FFT(LocalBuf(2048), bufferRead);
	// moves in and out of freeze
	chain = PV_MagSmear(chain, smear);

	(volMax * IFFT(chain))!2;

});
//generate a graphic interface with parameters specs
//Ndef(\fftMagnitudesSmear).gui;
Ndef(\fftMagnitudesSmear).addSpec(\smear, [0, 100, \lin]);
Ndef(\fftMagnitudesSmear).addSpec(\volMax, [0.5, 5, \lin]);
);




(
Ndef(\fftMagnitudesFreez, {
	arg rate=1, freez = 0, volMax = 1;
	var bufferRead = PlayBuf.ar(1, ~buffer, rate, loop: 1);
	var chain = FFT(LocalBuf(2048), bufferRead);
	// moves in and out of freeze
	chain = PV_MagFreeze(chain, freez );

	(volMax * IFFT(chain))!2;

});
//generate a graphic interface with parameters specs
//Ndef(\fftMagnitudesFreez).gui;
Ndef(\fftMagnitudesFreez).addSpec(\freez, [0, 1, \lin]);
Ndef(\fftMagnitudesFreez).addSpec(\volMax, [0.5, 5, \lin]);
);



(
Ndef(\fftMagnitudesMultiplication, {
	arg rate=1, volMax = 1;
	//oscillator bank as a source
	var inA = Klang.ar(`[ [200, 1000, 3200], [0.1, 0.5, 0.3], [pi, pi, pi]], 1, 0) * 0.9;
	var bufferRead = PlayBuf.ar(1, ~buffer, rate, loop: 1);
	var chainA = FFT(LocalBuf(2048), inA);
	var chainB = FFT(LocalBuf(2048), bufferRead);
	var chain = PV_MagMul(chainA, chainB);

	volMax * IFFT(chain);

});
//generate a graphic interface with parameters specs
//Ndef(\fftMagnitudesMultiplication).gui;
Ndef(\fftMagnitudesMultiplication).addSpec(\volMax, [0.5, 5, \lin]);
);


//granular buffer scanner
(
Ndef(\granular, {
	arg volMax = 1, pos = 0, tRate = 1, grDur;
	var clk, pan;
	clk = Impulse.kr(tRate);
	pan = WhiteNoise.kr(0.6);
	TGrains.ar(2, clk, ~buffer, 1, pos, grDur, pan, 0.9 * volMax);
});
//Ndef(\granular).gui;
Ndef(\granular).addSpec(\volMax, [0.5, 5, \lin]);
Ndef(\granular).addSpec(\pos, [0, ~buffer.duration, \lin]);
Ndef(\granular).addSpec(\tRate, [1, 1000, \exp]);
Ndef(\granular).addSpec(\grDur, [0.01, 1, \lin]);
);

(
Ndef(\filter, {
	arg freq, rq, pan, amp;
	var filter = BPF.ar(\input.ar, freq, rq);
	var panning = Pan2.ar(filter, pan, amp);
	panning;
});
);

(
Ndef(\delay, {|maxdelaytime = 5, delaytime = 1|
	var delay = DelayC.ar(\input.ar, maxdelaytime, delaytime);

	[delay, \input.ar];
})
)














