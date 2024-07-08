/////////////////////////////////////////////////////////////////////////////
//individual code goes below

//fft scrambler
(
Ndef(\fftBinScrambler, {
	arg rate=1, wipe = 0, width = 1, pulseRate =1, volMax = 1;
	var bufferRead = PlayBuf.ar(1, ~buffer, rate, loop: 1);
	var pulse = Impulse.ar(pulseRate);
	var chain = FFT(LocalBuf(2048), bufferRead);
	// moves in and out of freeze
	chain = PV_BinScramble(chain, wipe, width, pulse);

	(volMax * IFFT(chain))!2;

});
//generate a graphic interface with parameters specs
Ndef(\fftBinScrambler).gui;
Ndef(\fftBinScrambler).addSpec(\wipe, [0, 1, \lin]);
Ndef(\fftBinScrambler).addSpec(\width, [0, 1, \lin]);
Ndef(\fftBinScrambler).addSpec(\pulseRate, [1, 1000, \lin]);
Ndef(\fftBinScrambler).addSpec(\volMax, [0.5, 5, \lin]);
Ndef(\fftBinScrambler).set(\fadeTime, 10);
//define extra processes toi be applied into "fftBinScrambler"
Ndef(\fftBinScrambler)[1] = \filterIn -> { |in, maxDT = 5, delayTlow = 0, delayThigh = 1|
	CombL.ar(in, maxDT, LFNoise2.kr(0.5!2).exprange(delayTlow, delayTlow+delayThigh), 3)
};
Ndef(\fftBinScrambler).addSpec(\maxDT, [0.05, 20, \lin]);
Ndef(\fftBinScrambler).addSpec(\delayTlow, [0.1, 20, \lin]);
Ndef(\fftBinScrambler).addSpec(\delayThigh, [0.5,20, \lin]);
Ndef(\fftBinScrambler)[2] = \filterIn -> { |in|
	PitchShift.ar(in, 1, LFSaw.ar(10).exprange(0.4, 4,), 1, 1)
};


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
Ndef(\fftMagnitudesSmear).gui;
Ndef(\fftMagnitudesSmear).addSpec(\smear, [0, 100, \lin]);
Ndef(\fftMagnitudesSmear).addSpec(\volMax, [0.5, 5, \lin]);
Ndef(\fftMagnitudesSmear).set(\fadeTime, 10);
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
Ndef(\fftMagnitudesFreez).gui;
Ndef(\fftMagnitudesFreez).addSpec(\freez, [0, 1, \lin]);
Ndef(\fftMagnitudesFreez).addSpec(\volMax, [0.5, 5, \lin]);
Ndef(\fftMagnitudesFreez).set(\fadeTime, 10);
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
Ndef(\fftMagnitudesMultiplication).gui;
Ndef(\fftMagnitudesMultiplication).addSpec(\volMax, [0.5, 5, \lin]);
Ndef(\fftMagnitudesMultiplication).set(\fadeTime, 10);
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
Ndef(\granular).gui;
Ndef(\granular).addSpec(\volMax, [0.5, 5, \lin]);
Ndef(\granular).addSpec(\pos, [0, ~buffer.duration, \lin]);
Ndef(\granular).addSpec(\tRate, [1, 1000, \exp]);
Ndef(\granular).addSpec(\grDur, [0.01, 1, \lin]);
Ndef(\granular).set(\fadeTime, 10);
);


(
Ndef(\delay, {|maxDelay = 5, delayTime = 1, decayT = 1|
	var rawInput = \input.ar;
	var delay = CombC.ar(rawInput, maxDelay, delayTime, decayT);

	[delay, rawInput];
});
Ndef(\delay).gui;
Ndef(\delay).addSpec(\maxDelay, [0.1, 20, \lin]);
Ndef(\delay).addSpec(\delayTime, [0.0, 20, \lin]);
Ndef(\delay).addSpec(\decayT, [0.0, 20, \lin]);
);

Ndef(\delay).set(\input, Ndef(\fftBinScrambler));


(
Ndef(\pitchShift, {
	arg pShiftRatio, tDispersion, pDispersion;
	var input = \input.ar;
	var pShift = PitchShift.ar(input,
		windowSize: 2,
		pitchRatio: pShiftRatio,
		pitchDispersion: pDispersion,
		timeDispersion: tDispersion
	);

	pShift;
});
Ndef(\pitchShift).gui;
Ndef(\pitchShift).addSpec(\pShiftRatio, [0.0, 4.0, \lin]);
Ndef(\pitchShift).addSpec(\pDispersion, [0.0, 1.0, \lin]);
Ndef(\pitchShift).addSpec(\tDispersion, [0.0, 1.0, \lin]);
Ndef(\pitchShift).set(\input, Ndef(\delay));
)







