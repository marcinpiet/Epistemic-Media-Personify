
Ndef(\test);

Ndef(\test).play;

Ndef(\test).source = {SinOsc.ar(LFSaw.kr(1.1).exprange(10, 1000))};

Ndef(\test).stop;

//sine oscillator as ndef
Ndef(\test).source = {
	//arguments for frequency, pan and amplitude
	arg freq = 440, pan = 0, amp = 0.1;

	var sound = SinOsc.ar(freq);
	var panner = Pan2.ar(sound, pan, amp);

	panner;

}

//cmd+m to open the monitor

Ndef(\test).set(\freq, 392, \pan, 0);
Ndef(\test).stop;

/////////////////////////////////////////////////////////
Ndef(\stereoSine)[0] = {
	//arguments for frequency, pan and amplitude
	arg freq = 440, pan = 0, amp = 0.1;
	var sound = SinOsc.ar(freq);
	var panner = Pan2.ar(sound, pan, amp);

	panner;

};

//generate GUI
Ndef(\stereoSine).gui;

Ndef(\stereoSine).play;

//add processes
Ndef(\stereoSine)[1] = \filterIn -> { arg in; CombL.ar(in, 0.2, LFNoise2.kr(0.5!2).exprange(0.01, 0.2), 3) };

Ndef(\stereoSine)[2] = \filterIn -> { arg in; GVerb.ar(in, damping: 0.1) };
//changing the source
Ndef(\stereoSine)[0] = { RLPF.ar(Dust2.ar(5!2), LFNoise2.kr(2!2).exprange(200, 5000), 0.05) };

//removing processes
Ndef(\stereoSine)[1] = nil;
Ndef(\stereoSine)[2] = nil;
Ndef(\stereoSine)[0] = nil;

//complex ndef with ndefs inside

//main sound source
(
Ndef(\a).source = { Ringz.ar(Ndef.ar(\b), [350, 351.3] * 2, 0.4) };
//process
Ndef(\b, { LFSaw.ar([5, 7]/2, [0, 0.5], 0.15) });
Ndef(\a).play;
);

//recursive processes
Ndef(\sound, { SinOsc.ar([600, 635], Ndef.ar(\sound), LFNoise1.kr(2).max(0) * 0.2) });
Ndef(\sound).play;
Ndef.clear;


//writing ndef from scratch

Ndef(\test).gui;
Ndef(\test)[0] = {
	arg freq = 10;
	var osc = LatoocarfianC.ar(MouseX.kr(20, SampleRate.ir));
	osc;
};

Ndef(\test)[1] = \filterIn -> {|in, freqR| Ringz.ar(in, freqR, 0.5)}

Ndef(\test).addSpec(\freqR, [20, 40000, \lin]);
Ndef(\test).addSpec(\damp, [0, 1, \lin]);

Ndef(\test)[2] = \filterIn -> {|in, damp = 0.5| GVerb.ar(in, 30, 10, damp)}


//////////////////////////////////////////////////////////////////////////
//ndef and patterns

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

Ndef(\grain)[0] = { |grainDur = 0.1, freq = 200, amp = 0.5|

	var trate, dur, rate;
    trate = MouseY.kr(2,200,1);
    dur = 4 / trate;
    rate = Dseq([10, 1, 1, 0.5, 0.5, 0.2, 0.1], inf);
    TGrains.ar(2, Impulse.ar(trate), b, rate, MouseX.kr(0,BufDur.kr(b)), dur, Dseq([-1, 1], inf), 0.1, 2);

};

Ndef(\grain).play;
Ndef(\trigger, {LFNoise2.ar(10)});
//define a pattern to play arguments of \grain

Ndef(\grain)[1] = \xset -> Pbind(
	\dur, Pbrown(0.01, 1),
	\freq, Pseq([1440, 1346, 234, 1923], inf),
	\grainDur, Pseq([0.01, 0.1, 0.3, 0.5], inf),
	\damp, Pbrown(0.0, 1)
);

Ndef(\grain)[2] = \filterIn -> {|in, damp = 0.5| GVerb.ar(in, 30, 10, damp)};
Ndef(\grain).addSpec(\damp, [0, 1, \lin]);

Ndef(\grain)[3] = \filterIn -> {|in| RLPF.ar(in, LFNoise2.kr(2!2).exprange(200, 5000), 0.05) };



b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

(
Ndef(\player)[0] = { |grainDur = 0.1, freq = 200, amp = 0.5|

	PlayBuf.ar(1, b, SinOsc.ar(1.1).range(0.5, 1.5), BufRateScale.kr(b), loop: 1)

};
)

GrainIn



Ndef(\test)[0] = { SinOsc.ar(3451) * SinOsc.ar(1)};


Ndef(\whatever, { LFSaw.ar(Ndef(\test) * 100 ) }).play;



