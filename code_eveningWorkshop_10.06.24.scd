//code for everyone

(
//start up code for everyone
//start the server
s.waitForBoot({
	//level meeter
	s.meter;
	//how many seconds are we listening to?
	~memorySize = 12; //set it to desired value
	//buffer
	~buffer = Buffer.alloc(s, s.sampleRate * ~memorySize);
	//visualise the buffer if there is anything recording
	~plotter = Plotter("live buffer plot");
	//plot settings
	~plotter.setProperties(
		\fontColor, Color.red,
		\plotColor, Color.red,
		\backgroundColor, Color.gray,
		\gridColorX, Color.white
	);
	~plotter.refresh;
})
);

/////////////////////////////////////////////////////////////////////////////
//individual code goes below

(
Ndef(\listener, {
	arg rate=1;

	//listens to incoming audio
    var in = SoundIn.ar(0);

	//writes into a buffer
	BufWr.ar(in, ~buffer, Phasor.ar(0, BufRateScale.kr(~buffer) * rate, 0, BufFrames.kr(~buffer)), loop: 0);

	//doesn't play anything only listens
    0.0 //quiet
});
);

//listen and record for given length of time, time set above as ~memorySize
//display the recorded buffer
(
Tdef(\record, { 1.do{
	Ndef(\listener).play; Tdef(\bufferVisualisation).play; "recording".postln;
	~memorySize.wait;
	Ndef(\listener).free; Tdef(\bufferVisualisation).stop; "recording stopped".postln
} }
);
//visualise the recording buffer
Tdef(\bufferVisualisation, {
	loop{
		~buffer.getToFloatArray(wait:0.01,action:{arg array; { ~plotter.value = array; }.defer;});
		0.01.wait;
	}
});
Tdef(\record).play;
);

//replay what recorded
(
Ndef(\rePlay, {
	arg rate=1;
	var bufferRead = PlayBuf.ar(1, ~buffer, rate, loop: 1);

	bufferRead;

});
);

//generate a graphic interface
Ndef(\rePlay).gui;


//fft scrambler
(
Ndef(\fftBinScrambler, {
	arg rate=1, wipe = 0, width = 1, pulseRate =1;
	var bufferRead = PlayBuf.ar(1, ~buffer, rate, loop: 1);
	var pulse = Impulse.ar(pulseRate);
	var chain = FFT(LocalBuf(2048), bufferRead);
    // moves in and out of freeze
    chain = PV_BinScramble(chain, wipe, width, pulse);

	0.5 * IFFT(chain);

});
);

//generate a graphic interface with parameters specs
Ndef(\fftBinScrambler).gui;
Ndef(\fftBinScrambler).addSpec(\wipe, [0, 1, \lin]);
Ndef(\fftBinScrambler).addSpec(\width, [0, 1, \lin]);
Ndef(\fftBinScrambler).addSpec(\pulseRate, [1, 1000, \lin]);

(
Ndef(\fftMagnitudesSmear, {
	arg rate=1, smear = 1;
	var bufferRead = PlayBuf.ar(1, ~buffer, rate, loop: 1);
	var chain = FFT(LocalBuf(2048), bufferRead);
    // moves in and out of freeze
    chain = PV_MagSmear(chain, smear);

	0.5 * IFFT(chain);

});
);

//generate a graphic interface with parameters specs
(
Ndef(\fftMagnitudesSmear).gui;
Ndef(\fftMagnitudesSmear).addSpec(\smear, [0, 100, \lin]);
)






