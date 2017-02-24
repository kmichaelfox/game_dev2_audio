//execute lines by holding shift and pressing return

// arithmetic
1 + 1;

// strings
"strings";

// all primitives are objects, executing them returns the object's value.
// we can use this to add function calls to the objects, such as printing
// to the console
"strings".postln;

// notice that the above example returns the value of the object, which is
// printed to the Post window, and the postln function also prints the
// string to the Post window

// variables are a little different in supercollider... SC pays strict
// attention to scope, as in other languages. However, SC enforces
// special syntax for different kinds of variables.

// at this scope, which is the file level or global scope, we must define
// and set variables in one of two ways: is using a single lowercase
// letter ranged a-z

a = 9;
a.postln;

// alphabetic letters are terrible for longterm use, since they don't
// describe anything. if we want to get a little more specific, we
// can use the other form, which is a ~ character followed by alpha-
// numeric characters of any case (as well as underscore)

~thisIsValid = 14;

~so_is_this = 3;

~me2 = 8;

// normal arithmetic with the variables we have set
~me2 + ~thisIsValid;

~so_is_this + a;

a + "random message";

// in the last example we did something funny. we added objects of
// two different types. certain operators are clever enough to figure
// out what you mean, but it also points out something the we didn't do
// before: define the variable type.

// another funny trick with these operations is the use of parentheses.
// from algebra, we know how parens are use to group operations and
// dictate their order of execution
5 * (4 + 1);

// but in SC, the parens can also be a fully-fledged object in themselves.
// check it out:
~parens = ();

// notice how the initialization returned an empty set of parens in the
// Post window? this is because we have actually set ~parens to an object
// type referred to in SC as an Event
().class;

// execute the following to see the documentation for the Event class:
Event.help;

// this quickly gets into some territory we're not quite ready for,
// but 99% of the time we'll be using parens to execute groups of code
// lines all at the same time. for this reason, i'm going to call them
// blocks, unless we have a good reason to call them something else
// later.

// the two ways to execute code groups are to highlight the parens and
// everything in between and press shift+return as we have been doing.

// otherwise, we can click anywhere within the top level parens and
// press cmd+return or ctrl+return
(
~thisIsValid * 9;
~me2 * 9;
)

// in the last example we only got one value back from the execution
// of the code block. this is because the block only returns the value
// from the last expression evaluated in the block.

// we can still post any lines we want, however, as well as mix and
// match parentheses levels:
(
"".postln;
(~thisIsValid * 9).postln;
(~me2 * 9).postln;
b = 13;
)

// back to variables - if you now execute 'b', you'll get the variable
// we set inside the block.
b;

// we don't usually want to flood the global variable space, so we
// use a different syntax for scoped variables:
(
var b, hakuna_matata;

b = 444;
b.postln;

hakuna_matata = 19;
hakuna_matata.postln;
)

// and if we execute our global b again:
b;

// a few notes: first, you can not have multiple var lines in a scope,
// or else you'll get a syntax error. bummer, but that's the way it is.
// plus, you have to put the var declarations on the first line.

// also, what the what? why not just use var declarations at all levels?
// well, that is because the 'var' keyword helps make certain that the
// variables you are using are differentiated from global scope and they
// are also destroyed immediately at the end of the scope they are contained
// within. this is the same as other languages, but SC is a quirky language
// that is frustratingly contradictory at times and chose to enforce this
// one thing syntactically. in the case of var declarations at the global
// scope, they actually return nil and are released right after definition,
// so you don't even get a chance to try to use them.

// but don't take levar burton's word for it:
var nachos = 99;
nachos.postln;

// it don't work.





// okay, basic syntactic stuff aside, why are we talking so much about the
// language to start, instead of making sound?

// well, first SC can be a bit of a chore to learn, since it does some things
// very flexibly and other things both highly idiosyncractically and very
// inflexibly.

// this is in part due to the structure of SC itself. there are in fact two
// different parts of SuperCollider. the first is 'sclang', which we have
// been getting to know. the second is 'scsynth'. within the IDE, or any other
// IDE (such as Sublime Text, EMACS, etc.) that has been setup to use sclang,
// we have the interpreting and parsing layer of the language. this means that
// sclang figures out what your SC code is supposed to do and transforms that
// code into different code that the program knows how to do.

// what is super weird about SC, however, is that the language that it is
// translating your code into is a strangely formatted TCP/UDP packet. the
// specification for the implementation is Open Sound Control, or OSC.

// so if all of your sclang code is converted to network packets, then where
// are they going? the answer is: 'scsynth'. as such, scsynth is a server that
// must be booted and runs externally from sclang. in the simplest case, you
// are booting a server on your own computer and sending sclang sends its
// packets to that local server. however, other configurations can involve
// really weird configurations, such as one client talking to 10 remote servers or
// 20 clients all talking to a single remote server. all you would need is
// the ip address and port of the computers hosting the scsynth servers.

// enough gab, this is how you do it:
s.boot;

// the previous command should make a bunch of stuff happen in the Post window.
// in case you got excited during the previous part of the demo and set 's' to
// something else, execute the following:
s = Server.local;
s.boot;

// since all of the code we executed before this involved simple printing,
// arithmetic and variable definition, we never actually needed to send
// any messages to the server.

// that changes now:
{ SinOsc.ar([400, 401], 0, 0.1) * Saw.ar([11, 33], 1) * EnvGen.kr(Env.sine(10)) }.play;
// borrowed from Mark Polishook tutorial

// THIS IS ONE OF THE MOST IMPORTANT NOTES SO FAR:
// at some point in your experiences using SC, you will make a sound so loud
// and ear piercing that it would make a banshee shift uncomfortably
// in their seat. at other times, you will simply want to stop playing sound.
// in either case, there is a quick keystroke that will stop all currently
// sounding nodes in the server. just press:
//
// cmd+period or ctrl+period



// back to the example from before. besides making sound, there is a new syntactic
// element that we haven't seen yet curly braces, or {}

// and what's more, these are getting a function/selector/method just like objects.
// well, that's because they are. in fact, they are very similar to the parentheses
// that make up Events, but here is the difference:

~global_event = (
	var tunguska = true;
	if(tunguska, {"mass extinction".postln;});
)
// it doesn't work, because SC doesn't allow you to store the state variables
// in this format.

~global_event = (
	"mass extinction".postln;
)
// this does work, but not in the way we expect...

~global_event.class;
// this shows us that what actually happened is all of the code was evaluated,
// and the return value was stored in the ~global_event variable


// Now try this:
(
~global_function = {
	var notTunguska = true;
	if(notTunguska, {"look for other evidence of alien influence".postln;});
};

~global_function.value;
)

// in SC, the language tries to reduce events that are created with parentheses
// to a final result, so they are evaluated when you execute the block. anything
// in curly braces, on the other hand, is a function. these store the code inside
// and wait to be executed, which we did above when we called ~global_function.value

// important distinction:
~global_function; // returns the function
~global_function.value; // evaluates the code inside and also returns a value

// and usually we expect functions to be able to take arguments, which we can do
// two different ways:
~another_func = { arg input;
	input.postln;
};

~yet_another_func = { |input|
	input.postln;
};

~one_last_func = { |input, differentInput|
	input.postln;
	differentInput.postln;
};

// we'll see below that these are totally equivalent, just some syntactic sugar.
// but we pass the arguments into the function by adding them to the value
// method/selector/operator.

~another_func.value(13);
~yet_another_func.value(7);
~one_last_func.value(6, 8);

// so, if we go back to the if statement we saw back in ~global_function, we can
// see that we put a function into the arguments. we do this with all of the control
// structures, which in some cases have strange syntax. we'll see those below:

if( true, // the test is a boolean expression, not a function
	{
		/* true function */
	},
	{
		/* false function, can be omitted */
	}
);

for(0 /* start index */, 10 /* end index, inclusive */,
	{ |index|
		/* this function can receive the index as an argument*/
		index.postln;
	}
);

while( { /* test function */ false }, {
	/* body function */
});

// and a couple of others that we don't need to worry about right now. but we
// saw that in these cases, the functions are automatically evaluated by the control
// structure, so you don't need to explicitly ask for their value.



// so we've detoured again, away from sound.
// let's take another look at the last sound we made:
{ SinOsc.ar([400, 401], 0, 0.1) * Saw.ar([11, 33], 1) * EnvGen.kr(Env.sine(10)) }.play;

// if you executed this line, you may want to press cmd+period before proceeding

// in the example above, we have made an anonymous function with a bunch of stuff in
// it, and then directly called "play" on it. since the function was full of sound-
// making stuff (how you tell this is coming soon), the effect of calling play on
// the function is to output the sound automatically to the speakers.

// you may be thinking to yourself: well, cmd+period kills all sound, and calling play
// on an anonymous function means that once we start it, we can't turn it back off
// without killing everything and everyone and everything sucks and what will we do...

// well, we could do this:
~deliverance = { SinOsc.ar([400, 401], 0, 0.1) * Saw.ar([11, 33], 1) * EnvGen.kr(Env.sine(10)) };

// now we can look at the documentation for Functions and see what we can do:
Function.help;

// about half way down there is a section called Audio with some stuff that looks
// like it could answer our question... lo and behold, the first method is play
~deliverance.play;

// the syntax for the method call might look a little weird. that's because they are
// displaying the method like so:
play(~deliverance);

// which is identical to the former notation. just something to keep in mind.
// okay but what else can we do? well, apparently we can scope:
~deliverance.scope;

// and we can plot:
~deliverance.plot;

// hmm, but still no clear way of turning it off...

// that is because there is another subtle complication here - the contents of
// our ~deliverance object is actually just an block of code

// remember how when we execute stuff, it returns something? this is the problem
// here. when we actually call ~deliverance.play, it is creating and returning
// the actual object that is making the sound. this object is called a Synth:
Synth.help;

// and this help file seems to say that we can kill Synth objects by calling
// .free on a reference to them.

// so i guess we could... do this?
~deliverance2_moarDelivered = ~deliverance.play;
~deliverance2_moarDelivered.free;

// hmm, it worked. but this is just ridiculous. we have to create new variables for
// everything and just... ugh.

// well, not exactly.

// in truth, supercollider allows you to do all of this stuff, but where it really
// shines is in how you don't have to. i mean to say that more often we work with
// equivalent, and more convenient, objects called SynthDefs
SynthDef.help;

// using SynthDefs is just about what it sounds like. they are templates that you,
// or someone else, has made for a synth object and it has a name. if you look in
// your post window, you'll notice that each time called play on ~deliverance, we
// got an object back that was called Synth("temp__*" : ****). our synths were
// effectively anonymous - a one of a kind thing synth that we presumably will use
// only once - but we were storing a reference to that anonymous synth.

// to be clear, you can have multiple synths of the same name that are in fact
// different objects. they are different instances of the same class. this makes
// a big difference because now we don't have to create a function, store it in
// a variable, and manually do this anymore:
~deliverance2_moarDelivered = ~deliverance.play; // no soup for you

// now, we can do stuff like this (ONE TIME):
(
SynthDef("deliverance", {
	SinOsc.ar([400, 401], 0, 0.1) * Saw.ar([11, 33], 1) * EnvGen.kr(Env.sine(10));
}).add;
)

~not_deliverance = Synth("deliverance");
~not_deliverance.free;

// hmm, no sound came out. that's because you have to manually assign where the sound
// is going to when you do stuff in a SynthDef. it sounds more complicated, but it
// really isn't and is actually way more powerful in the long run. anyways, here's
// how you do it, use some of the other stuff available to us as well (like vars):

(
SynthDef("deliverance", {
	var signal;

	// break up the signal into multiple lines for readability
	signal = SinOsc.ar([400, 401], 0, 0.1);
	signal = signal * Saw.ar([11, 33], 1);
	signal = signal * EnvGen.kr(Env.sine(10));

	// send the signal to the outputs
	Out.ar(0, signal);
	// in this case, 0 is a magic number corresponding to
	// audio output bus 0 (or else the left speaker channel)
}).add;
)

// let's try again:
~not_deliverance = Synth("deliverance");
~not_deliverance.free;

// boom. it works. let's do two at once!
~not_deliverance = Synth("deliverance");
~possibly_digiorno = Synth("deliverance");

~not_deliverance.free;
~possibly_digiorno.free;

// nothing to do now but sit back and wait for the money to fall into our laps.

// or i guess we could see a few more things first...

// first, i'd like to point out that we can re-initialize our synthdef with new
// code and the same name, and it will totally work. you can even doing it while
// it is running.

// second, if you were wearing headphones then you might have noticed there was
// a little bit of difference between the left and right speakers. this is due
// to something called multichannel expansion:

// in the case above, we can see in SinOsc.ar([400, 401], 0, 0.1)
// that array containing 400 and 401 is in the frequency argument spot, and
// it is effectively creating two SinOsc objects, one with 400 hz as its freq
// and another with 401 hz as its freq. otherwise, they are identical.

// in the next line we see the same thing in Saw.ar([11, 33], 1);
// just before that you'll notice that we're multiplying this saw into our
// previous signal, consisting of SinOsc.etc... in this case, SinOsc corresponding
// to array index 0 is multiplied into the Saw corresponding to index 0, and
// likewise with index 1.

// on the last line, we multiply in an EnvGen object, which is multiplied identically
// into both array indices of signal.

// when we add signal into Out.ar(0, signal), we're actually putting an array in for
// signal. and Out is smart enough to map these array indices of signal to the audio
// output bus indices. this means that signal[0] goes to audio output bus 0, or the
// left speaker. and the same with signal[1]->audio output bus 1.

// but say we had a mono signal:
(
SynthDef("otherStuff", {
	var signal;

	// break up the signal into multiple lines for readability
	signal = SinOsc.ar(400, 0, 0.1); // no array
	signal = signal * Saw.ar(11, 1); // no array
	signal = signal * EnvGen.kr(Env.sine(10));

	// send the signal to the outputs
	Out.ar(0, signal);
}).add;
)

// and if we create a synth:
~new_track = Synth("otherStuff");
~new_track.free;

// aha, only one speaker. the left. but if we want our mono signal to go to both
// speakers at the same time, we can just duplicate the signal INSIDE the Out
// object

(
SynthDef("otherStuff", {
	var signal;

	// break up the signal into multiple lines for readability
	signal = SinOsc.ar(400, 0, 0.1); // no array
	signal = signal * Saw.ar(11, 1); // no array
	signal = signal * EnvGen.kr(Env.sine(10));

	// send the signal to the outputs
	Out.ar(0, signal!2); // notice the factorial here ********
}).add;
)

// and make one play:
~new_track = Synth("otherStuff");
~new_track.free;

// it should be coming through both speakers now. what we did is a little
// sneaky - but totally valid. signal!2 takes signal, duplicates it, and puts
// these two signals into an array that goes back into the place that signal!2
// occupies.

// but using the speaker channels is just the default. i've had reason to send
// to 8 channels at once before, and this trick makes it easy to know where
// the signals are going. it isn't even a trick, really. it is one of the
// ways you are supposed to do it. cool.

// when i said that it defaults to output bus 0, i wasn't completely truthful.

// in fact, it defaults there, because that is what we have provided with our
// magic number. it is generally useful in that way, but we could change that
// number to make one synth play only left, and one synth only right.
(
SynthDef("otherStuff", { |out = 0| // i prefer pipes notation, but you could use 'arg'
	var signal;

	// break up the signal into multiple lines for readability
	signal = SinOsc.ar(400, 0, 0.1);
	signal = signal * Saw.ar(11, 1);
	signal = signal * EnvGen.kr(Env.sine(10));

	// send the signal to the outputs
	Out.ar(out, signal); // we replaced our magic number with our argument
}).add;
)

// a few things here. when we put the pipes around out = 0, we were creating an
// argument called 'out' that we used as the bus input of Out.ar(), or replaced
// our magic number. but when we said |out = 0|, instead of just |out|, we set
// a default value.
~new_track = Synth("otherStuff");
~new_track.free;

// That worked the same as what we had before, but we could also specify it.
// as always, we have to learn a new notation. when we pass the value for
// args into Synths - at the time we are creating them - we pass all of them
// in as a kind of interleaved array. it is kind of like Tuples, to borrow
// parliance from other languages. essentially, we providing our arguments
// in an array of pairs, where we put in a symbol (more on that in a moment)
// and its value. like so: [\symbol, value]

// if we were setting multiple arguments, it would go like this:
// [\symbol_1, value_1, \symbol_2, value_2, ..., ..., etc_1, etc_2]

// we could specify the arguments and their values in any order, however the
// value used for a symbol is the one that comes immediately after it.

// in other words, moving \symbol_2 to the front of the list means you must
// also move value_2, like so:
// [\symbol_2, value_2, \symbol_1, value_1, ..., ...]

// but about symbols... there isn't that much to say, other than they are
// usually interchangeable with strings when it comes to naming things.
// in fact, anytime we name something with a string, we can refer to it with
// a corresponding symbol as well. for example, we previously named our synthDef
// "otherStuff" and we create our synth with:
~new_track = Synth("otherStuff");
~new_track.free;

// but we can also do:
~new_track = Synth(\otherStuff);
~new_track.free;

// it's basically the same thing, and some of the differences are effectively
// subtle. besides just being much more powerful in the respect that you are
// clearly referring to an "ID"-like string, as opposed to some other string
// literal representing text or content, they enable a different class of
// boolean comparison. in this case, using symbols you can compare to see
// if two things are not just *basically* the same thing, but literally
// the same object. not just two different objects of the same class, but
// whether an object is itself, or is not. we don't really need to worry much
// more about this for now.

// from here on out, though, i'll be using symbols instead of strings.
// tl;dr - looks a little different, but pretty much the same

// but why did i even go down this rambling path? oh yeah, because we use
// symbols to identify our arguments when creating Synths. but what symbol
// should we use? when it comes to arguments, we just use the name of the
// argument we want to set. yep, just use the same word.

// like this:
~new_track = Synth(\otherStuff, [\out, 0]);
~new_track.free;

// so it doesn't do anything new. but it also didn't break, so we must have
// done something right. let's try it again with \out as the value of 1. if
// we recall from before, audio output bus 1 should be the right speaker channel
~new_track = Synth(\otherStuff, [\out, 1]);
~new_track.free;

// let's see what two arguments looks like. ah, heck. let's do three, so we
// can manually replicate the stereo version we originally had.
(
SynthDef("supaFreq", { |out = 0, sinFreq = 440, sawFreq = 11|
	var signal;

	// break up the signal into multiple lines for readability
	signal = SinOsc.ar(sinFreq, 0, 0.1); // using our argument here
	signal = signal * Saw.ar(sawFreq, 1); // and also here
	signal = signal * EnvGen.kr(Env.sine(10));

	// send the signal to the outputs
	Out.ar(out, signal);
}).add;
)

// if we recall from before, our left channel had out equals 0, SinOsc had a freq
// of 440, and Saw had a freq of 11. our right channel was out = 0, SinOsc's
// freq = 441, and Saw's freq = 33. let's try to wrap those up in Synth calls
// below:
(
~left_channel = Synth(\supaFreq, [\out, 0, \sinFreq, 440, \sawFreq, 11]);
~right_channel = Synth(\supaFreq, [\out, 1, \sinFreq, 441, \sawFreq, 33]);
)

(
~left_channel.free;
~right_channel.free;
)

// in the last case, i included all the arguments for the left channel to
// demonstrate my point, but if you look back at our actual SynthDef, you'll
// notice that our left channel's argument values are the same as the
// defaults we set.

// we could have done this instead:
(
~left_channel = Synth(\supaFreq);
~right_channel = Synth(\supaFreq, [\out, 1, \sinFreq, 441, \sawFreq, 33]);
)

(
~left_channel.free;
~right_channel.free;
)

// or we could have decided that the left channel was pretty good, but
// would it be nicer if everything was the same except the sawFreq:
(
~left_channel = Synth(\supaFreq, [\sawFreq, 25]); // using all defaults, except sawFreq
~right_channel = Synth(\supaFreq, [\out, 1, \sinFreq, 441, \sawFreq, 33]);
)

(
~left_channel.free;
~right_channel.free;
)

// the last thing i'll share is how you can change the values of these
// arguments in the middle of running them

// try the following:
(
SynthDef(\simpleSineSynth, { |out = 0, freq = 440|
	var signal;

	signal = SinOsc.ar(freq, 0, 0.1, 0);

	Out.ar(0, signal!2);
}).add;

~last_brutal_example_before_the_end = Synth(\simpleSineSynth);
)

// now we can change the frequency value thusly:
~last_brutal_example_before_the_end.set(\freq, 220);

// and finally turn off the synth
~last_brutal_example_before_the_end.free;




// that's all for now. SC had its origins in about 1996, so it has been around
// for 20 years at this point. that's a long time, and a lot of people use it.
// not to mention this is version 3 of the environment and language.

// i guess my point is that there is a lot of stuff inside SC that we could
// just never cover in one go. it is a massive environment with a lot of objects.

// so far we've only used SinOsc and Saw and EnvGen and Env and Out, but i didn't
// explain much about them. but i showed you how to look up the helpfiles internally
// and go you going enough to pick up from here. i tried to show you some of the
// particularly unique idioms of the language that are hard for beginners to
// recognize.

// from here, you can continue by looking up the tutorials that ship with SC by
// finding them in the help browser under the "Browse" tab. alternately you can
// consult the great all seeing Google. and if you really get into SC, there is an
// excellent Supercollider book that gets into some pretty hardcore stuff - it
// is a really great resource.

// but, naturally, the best thing to do from here, if you like the language, is to
// just use it a lot. and i hope you do.