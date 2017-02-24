// An attempt at algorithmically replicating the beginning of "Uncharted Worlds" - otherwise
// known as the Mass Effect map music...
//
// Youtube version (naturally, edited to be an hour long version):
// "https://www.youtube.com/watch?v=vGF-f3arb04"

s.boot;

( // SynthDefs
SynthDef.new(\MEReverb, { |out = 0, in|
	var sig = In.ar(in, 2); // grab audio buffer from our "in" bus
	sig = FreeVerb.ar(sig, mix: 1.0, room: 1.0, mul: 0.4); // apply reverb to "in"
	Out.ar(out, sig); // output to speakers
}).add;

SynthDef.new(\MEDelay, { |out = 0, in, reverbBus|
	var sig = In.ar(in, 2) + LocalIn.ar(2); // LocalIn is internal feedback input
	LocalOut.ar(DelayL.ar(sig, 2, 1)*0.6); // LocalOut is internal feedback output
	Out.ar(out, sig); // output to speakers
	Out.ar(reverbBus, sig); // output also to reverb
}).add;

SynthDef.new(\MEOstinato, { |revBus, delBus, midiNote, dur|
	var env, gen, sig, freq, freq2, freq3;

	freq = midiNote.midicps; // one freq at midiNote
	freq2 = (midiNote + 12).midicps; // another freq one octave up from midiNote
	freq3 = (midiNote).midicps * 1.0006; // another freq at midiNote and slightly detuned

	env = EnvGen.kr(Env([0, 1, 0],[0.001, 1], curve:-10), doneAction:2);
	sig = RLPF.ar(
		Mix.ar( // Mix will sum all signal objects contained in its first argument
			Saw.ar([freq, freq2, freq3], 0.05, 0); // arrays create a Saw object for each value
		),
		freq * 2, // cutoff freq of low pass filter
		0.5); // Q value of low pass filter

	Out.ar(0, env * sig!2); // output to speakers (after expanding to two channels)
	Out.ar(revBus, env * sig!2); // output to reverb bus (after expanding to two channels)
	if(delBus.notNil, { // if delBus is not explicitly set to a value that is not nil
		Out.ar(delBus, env * sig!2); // then output to delay bus (after expanding to two channels)
	});
}).add;

SynthDef.new(\MEBass, { |midiNote|
	var env, sig, freq;
	freq = midiNote.midicps;
	env = EnvGen.kr(Env(times:[0.01, 2], curve:-2), doneAction:2); // simple envelope
	sig = env * RLPF.ar(Saw.ar(freq, mul: 0.2), freq * 1.5, 0.5); // creae low pass filtered osc
	Out.ar(0, sig!2); // output to speakers (after expanding to two channels)
}).add;
) //end_synthdefs




( // Composition Structures
// Reverb and Delay busses
~reverbBus = Bus.audio(s, 2); // s: server, 2: number of channels
~delayBus = Bus.audio(s, 2);

// create single Reverb Synth
~reverb = Synth(\MEReverb, [\in, ~reverbBus.index]);

// create single Delay Synth
~delay = Synth(\MEDelay, [\in, ~delayBus.index, \reverbBus, ~reverbBus.index]);

// create our bar, beat, and incrementer
~bar = 1;
~beat = 1; // 1/8th notes

~tick = {
	~beat = ~beat + 1; // increment ~beat up
	if(~beat > 16, // if our beat is over 16
		{
			~beat = 1; // then set back to 1
			~bar = ~bar + 1; // and increment bar
		}
	);

	// post our sequence location as bar and beat numbers
	"Bar: ".post;
	~bar.post;
	", Beat: ".post;
	~beat.postln;
};



// create our note sequence for ostinato voice, located in main loop
a = Pseq([-5, -2, -5, -5, 0, -7, -5, 2], inf);
b = a.asStream; // make our sequence into a stream

// create our inner voice note sequence
c = Pseq([0, -2, -3, -2, 0, 2], inf);
// create our bass note duration sequence
d = Pseq([2/8, 2/8, 2/8, 4/8, 4/8, 2/8], inf);

// make our inner voice sequences into streams
e = c.asStream;
f = d.asStream;


// routine for inner voice
~innerVoice = Routine({
	loop({
		Synth(\MEOstinato,
			[
				\revBus, ~reverbBus.index,
				\delBus, ~delayBus.index,
				\midiNote, (e.next + (12 * 6))
			]
		);

		f.next.wait;
	})
});




// create initial bass note sequence, make into stream
~bassNotes = Pseq([-5], inf).asStream;
// create initial bass note duration value
~bassNotesDuration = 4;

// create our bass voice Routine
~bassVoice = Routine({
	loop({
		Synth(\MEBass,
			[
				\midiNote, (~bassNotes.next + (12 * 4))
			]
		);

		~bassNotesDuration.wait;
	})
});


// initialize note value for accent beats
~accentBeatNote = 7 + (12 * 6);
// create sequence of time delays between accent beats, make into stream
~accentBeatDurations = Pseq([4/8, 12/8], inf).asStream;

// create accent beats routine
~accentBeats = Routine({
	loop({
		Synth(\MEOstinato,
			[
				\revBus, ~reverbBus.index,
				\delBus, nil, // do not apply reverb to Synths playing accent beats
				\midiNote, ~accentBeatNote
			]
		);

		~accentBeatDurations.next.wait;
	});
});

// create sequence for three notes voice and make into stream
~threeNotes = Pseq([-2, -5, 0, -5, 2, -5], inf).asStream;

// create Routine for three notes sequence
~threeNotesRoutine = Routine({
	loop({
		Synth(\MEOstinato,
			[
				\revBus, ~reverbBus.index,
				\delBus, nil,
				\midiNote, (~threeNotes.next + (12 * 7)),
				\sustain, 2/8
			]
		);

		(2/8).wait; // loop waits a quarter of a second between beats
	})
});


// create our automation function
~automator = {
	// start bass voice in bar 3, beat 1
	if ((~bar == 2) && (~beat == 1),
		{
			~bassVoice.play;
		}
	);

	// change bass voice durations in bar 3, beat 1
	if ((~bar == 3) && (~beat == 8),
		{
			~bassNotesDuration = 2;
		}
	);

	// start inner voice in bar 4, beat 1
	if((~bar == 4) && (~beat == 1),
		{
			~innerVoice.play;
		}
	);

	// start accent beats in bar 5, beat 3
	if((~bar == 5) && (~beat == 13),
		{
			~accentBeats.play;
		}
	);

	// start three notes in bar 6, beat 1
	if((~bar == 8) && (~beat == 1),
		{
			~threeNotesRoutine.play;
		}
	);

	// change bass voice notes in bar 6, beat 1
	if((~bar == 8) && (~beat == 9),
		{
			~bassNotes = Pseq([-12, -12, -12, -12, -5, -5 ,-5 ,-5], inf).asStream;
		}
	);
};
) // end_composition_structures





( // main loop

// print our intial bar and beat (1 and 1)
"Bar: ".post;
~bar.post;
", Beat: ".post;
~beat.postln;

// our main routine that calls automator and the ostinato synth
Routine({
	loop({
		~automator.value; // change state if something new should happen on this beat

		Synth(\MEOstinato,
			[
				\revBus, ~reverbBus.index,
				\delBus, ~delayBus.index,
				\midiNote, (b.next + (12 * 4)),
				\dur, 2/8
			]
		);
		(2/8).wait;
		~tick.value;
	})
}).play;
) // end_main_loop

// clean up all of our resources when we are done
s.freeAll; // does not turn off loops