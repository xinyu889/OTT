import wave
file = 'Nello.wav'
wavefile = wave.open(file,'r')

nchannels = wavefile.getnchannels()
sample_width = wavefile.getsampwidth()
framerate = wavefile.getframerate()
numframes = wavefile.getnframes()

print("channel",nchannels)
print("sample_width",sample_width)
print("framerate",framerate)
print("numframes",numframes)
