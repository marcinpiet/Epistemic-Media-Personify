// simple text reading methods
"hi, this is the default voice speaking about ultrasound".say;
"hi, this is the first voice speaking.".say(0);
"hi, this is a voice speaking that was selected by name.".say("Alex");
"hi, dies ist hoffentlich eine deutsche Stimme, ausgesucht durch die Sprache.".say(lang: \de);

// each voice has a name, a language symbol, and an example text:
v = Say.voices.choose;
// say the example text of a specific voice:
v.exampleText.say(v.name);



b = Buffer.alloc(s, 44100 * 2);

(
Tdef(\listenAndPlay, {
	loop {
		b = Buffer.alloc(s, 44100 * 2);
		1.wait;
		l = {
			var listener = SoundIn.ar(0);
			var pitch = Pitch.kr(listener)[0];
			var stoch = Gendy3.ar(5.rand, 5.rand, 1.0.rand, 1.0.rand, 2.rand * pitch);

			stoch;
		}.play;
		s = {
			var input = SoundIn.ar(0);
			var record = BufWr.ar(input, b.bufnum, Phasor.ar(0, BufRateScale.kr(b.bufnum) * 1, 0, BufFrames.kr(b.bufnum)));
			0.0
		}.play;
		//"hi, dies ist hoffentlich eine deutsche Stimme, ausgesucht durch die Sprache.".say(lang: \en);
		5.wait;
		s.stop;
		l.stop;
		p = {
			var bufPlay = BufRd.ar(1, b.bufnum, Phasor.ar(0, BufRateScale.kr(b.bufnum) * 1, 0, BufFrames.kr(b)));
			bufPlay;
		}.play;
		5. wait;
		p.stop;
		b.free;
		1.wait;
}
}).play;
)