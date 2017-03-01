# Music, Audio, and Procedural Generation in Games

## Table of Contents
* [Audio and Music](#audio-and-music)
* [Procedural Generation](#proc-gen)
* [Resources](#resources)
  * [General Audio Resources](#audio-resources)
  * [SuperCollider Resources](#sc-resources)
  * [Game Engine Plugin Resources](#game-engine-plugin-resources)

## <a name="audio-and-music"></a>Audio and Music

Just like when you are programming your game mechanics or creating your
art assets, there are a lot of things to consider for the sound and music
in your game beyond just the creative or aesthetic components. This section
will describe some of the most important basics that are worth your attention.

### The role of audio and music in games

In-class Discussion, I'll update this to reflect the discussion after class.

References:

[Leonard Paul, "Interactive Sound Design", Game Sound Con 2009](http://www.videogameaudio.com/GameSoundCon-Nov2009/GameSoundCon2009-LPaul.pdf)

[Leonard Paul's Talk at RPI (Spring 2015)](http://videogameaudio.com/RPI-Oct2015/RPI-IntroToVideoGameAudio-Oct2015-VideoGameAudioCOM.pdf)

### Making your sound effects sound 'good'

People who edit sound all day every day will tell you that mixing and mastering
audio is an art. And it is. But there are a few basic things that anyone can,
AND SHOULD, do to make their audio instantly sound a lot better.

#### Normalize your sound effects

When you make or download your sound effects, they could be any volume at all.
Without getting their levels closer, some are going to be too loud and some
will be totally inaudible. Not good.

To fix this, you can either drop all of your sound effects into your game and
very manually edit the volume of each one. But every time you add a new sound,
you might have to go back and reset the level on most or every other sound.

Your other option is to use an application like Audacity to _normalize_ the
sound file, meaning you change the volume of the whole file so that the loudest
parts fall right around a specific point (typically just inside of [-1, 1]).

#### Use compression (A LITTLE)

DANGER! Compression is super useful, but a little bit goes a long way. So don't
overdo it.

Compression is similar to, but sort of the opposite of normalizing. Compression
essentially raises the volume of the quieter parts to be closer to the louder
parts. Using a little compression, you can make a sound that seems "thin" get
just a little more of what we might describe as "presence".

#### Watch out for too frequencies in the same range

If you have too many sound effects and or musical elements that are all in the
same exact frequency range, your ears are going to have a lot of trouble telling
where one begins and another ends.

For example, if you have spoken dialogue in your game, you don't want any music
playing at the same time to have a lot going on in the same frequency range as
the human voice (~85 to 255 Hz). You would be able to hear that someone was
speaking, but you would have a difficult time making out just what they are saying.

In this case, you move some of your music to a different instrument in a higher
or lower frequency range. Or you could use a filter to bring down the volume of
background (FX or music) in the range near the human voice. You have lots of
options, so if you end up having this problem, lets talk about it.

## <a name="proc-gen"></a>Procedural Generation

First, a field trip...

[Super Mario Bros.](https://gist.github.com/1wErt3r/4048722)

Now that we've seen that, we're going to use Unity and SuperCollider to see how
we can trigger live sounds and music from our game. This will mostly be an
in-class demo. I'll update the information here to reflect what we get to during
the demo.

Some stuff we'll need:

[Unity OSC](https://github.com/jorgegarcia/UnityOSC)
[Unity OSC Manual](https://github.com/jorgegarcia/UnityOSC/blob/master/docs/UnityOSC_manual.pdf)

## <a name="resources"></a>Resources

### <a name="audio-resources"></a>General Audio Resources

[Audacity](http://www.audacityteam.org/)

A simple, powerful, open source audio editing application. This should be your
first stop if you are new to editing audio!

[Reaper](http://www.reaper.fm/)

A feature-rich, very inexpensive Digital Audio Workstation - 60-day free
evaluation and $60 dollars for non-commercial use (translation: you won't make
more than $20,000 a year using this software). It works on Windows and MacOS.

### <a name="sc-resources"></a>SuperCollider Resources

[Download SuperCollider](http://supercollider.github.io)

[Eli Fieldsteel's Youtube SC Tutorial Series](https://www.youtube.com/playlist?list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC)

[Nick Collins SuperCollider Tutorial](http://composerprogrammer.com/teaching/supercollider/sctutorial/tutorial.html)

### <a name="game-engine-plugin-resources"></a>Game Engine Plugin Resources

[FMod](http://fmod.com/)

[Wwise](https://www.audiokinetic.com/products/wwise/)

Writing your own plugins:

Unity
* [Unity Manual: Native Plugins](https://docs.unity3d.com/Manual/NativePlugins.html)
* [Unity Manual: Low-Level Native Plugin Interface](https://docs.unity3d.com/Manual/NativePluginInterface.html)
* [Unity Manual: Native Audio Plugin SDK](https://docs.unity3d.com/Manual/AudioMixerNativeAudioPlugin.html)

Unreal Engine 4
* [UE 4 Docs: Plugins](https://docs.unrealengine.com/latest/INT/Programming/Plugins/)

Using PureData instead of SuperCollider

SuperCollider is my audio programming environment of choice, but there are many
reasons why it might not work for you or your game. If that is the case for
you, another option is PureData (PD). PD is a very close relative of Max/MSP,
written by the same person who wrote the original version of Max, and is a
powerful graphical programming language for real-time audio synthesis.

It has a lot of support at this stage from people who are experimenting with
procedural generation of audio in games, though it still has its limitations.

If you'd like to use PD, you'll want to download and familiarize yourself with
the software, then check out the online compiler tool _Heavy_. Heavy will take
your PD patches, translate them into C source code, and build the source into
several binary libraries as well as Unity Plugins. You can just download the
results and include them in your game. Unreal Engine will require a few more
steps that I won't describe here, but it does work!

[Get PureData](https://puredata.info/)

[Learn PureData](http://www.pd-tutorial.com/)

[Learn More PureData (and electronic music techniques)](http://msp.ucsd.edu/techniques.htm)

[Learn Even Moar PureDataz!!?!](https://puredata.info/docs/tutorials)

[Heavy](https://enzienaudio.com/)
