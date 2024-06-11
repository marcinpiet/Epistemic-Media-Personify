//code for everyone

(
//start up code for everyone
//start the server
s.boot;
//level meeter
s.meter;
//how many seconds are we listening to?
~memorySize = 5; //set it to desired value
//buffer
~buffer = Buffer.alloc(s, 48000 * 5);
//visualise the buffer if there is anything recording
~plotter = Plotter("live buffer plot");
);

/////////////////////////////////////////////////////////////////////////////
//individual code goes below

(
Ndef(\listener, {
	arg rate=1;

	//listens to incoming audio
    var in = SoundIn.ar(0);

	//writes into a buffer
	BufWr.ar(in, ~buffer, Phasor.ar(0, BufRateScale.kr(~buffer) * rate, 0, BufFrames.kr(~buffer)));

	//doesn't play anything only listens
    0.0 //quiet
});
);

Ndef(\listener).play;

//visualise the recording buffer
(
Tdef(\bufferVisualisation, {

	loop{
		~buffer.getToFloatArray(wait:0.01,action:{arg array; { ~plotter.value = array; }.defer;});
		0.01.wait;
	}
}).play;
)


(
Ndef(\resynthesiser, {
	arg rate=1, inter=2;

	var bufferRead = BufRd.ar(1, ~buffer, Phasor.ar(0, BufRateScale.kr(~buffer) * rate, 0,BufFrames.kr(~buffer)), 1, inter);
	var multiply = [bufferRead, bufferRead];

	multiply;
});
)

Ndef(\resynthesiser).play;
Ndef(\resynthesiser).stop;


(
Ndef(\resynthesiser02, {
	arg rate=1, position, trig = 1;

	var trigger = Impulse.ar(trig);
	var bufferRead = PlayBuf.ar(1, ~buffer, rate, trigger: trigger, startPos: position, loop: 1);
	var env = EnvGen.kr(Env.linen(), gate: trigger);

	bufferRead * env;

});
)

//generate a graphic interface
Ndef(\resynthesiser02).gui;

Ndef(\resynthesiser02).addSpec(\position, [0, ~buffer.numFrames, \lin] );
Ndef(\resynthesiser02).addSpec(\trig, [0.001, 1000, \exp] );

Ndef(\resynthesiser02).play;
Ndef(\resynthesiser).stop;











