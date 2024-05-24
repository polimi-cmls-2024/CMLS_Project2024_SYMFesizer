/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin processor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
ProjectAudioProcessor::ProjectAudioProcessor()
#ifndef JucePlugin_PreferredChannelConfigurations
    : AudioProcessor(BusesProperties()
                     #if ! JucePlugin_IsMidiEffect
                      #if ! JucePlugin_IsSynth
                       .withInput  ("Input",  juce::AudioChannelSet::stereo(), true)
                      #endif
                       .withOutput ("Output", juce::AudioChannelSet::stereo(), true)
                     #endif
                       )
    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    // SYMFesizer

    // Instatiation of the AudioProcessorValueTreeState in the constructor
    , apvts(*this, nullptr, "Parameters", createParameters())

    
    
    // Instatiation of the chorus in the constructor
    , chorus()

    // Instatiation of the panner in the constructor
    , panner()
     
    // Instatiation of the compressor in the constructor
    , compressor()
    
    // Instatiation of the phaser in the constructor
    , phaser()

    
    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#endif
{
    if (!connect(8000)) {
        std::cerr << "Unable to connect to port numero_della_porta\n";
    }
       
    // to handle messages sent to this particular address
    
        juce::OSCReceiver::addListener(this, "/chorus/rate");
        juce::OSCReceiver::addListener(this, "/chorus/depth");
        juce::OSCReceiver::addListener(this, "/chorus/centreDelay");
        juce::OSCReceiver::addListener(this, "/chorus/feedback"); 
        juce::OSCReceiver::addListener(this, "/chorus/mix");
        juce::OSCReceiver::addListener(this, "/panner/value");
        juce::OSCReceiver::addListener(this, "/compressor/threshold");
        juce::OSCReceiver::addListener(this, "/compressor/ratio");
        juce::OSCReceiver::addListener(this, "/compressor/attack");
        juce::OSCReceiver::addListener(this, "/compressor/release");
        juce::OSCReceiver::addListener(this, "/phaser/rate");
        juce::OSCReceiver::addListener(this, "/phaser/depth");
        juce::OSCReceiver::addListener(this, "/phaser/centreFrequency");
        juce::OSCReceiver::addListener(this, "/phaser/feedback"); 
        juce::OSCReceiver::addListener(this, "/phaser/mix");
        
    
  
}

ProjectAudioProcessor::~ProjectAudioProcessor()
{
}

//==============================================================================
const juce::String ProjectAudioProcessor::getName() const
{
    return JucePlugin_Name;
}

bool ProjectAudioProcessor::acceptsMidi() const
{
   #if JucePlugin_WantsMidiInput
    return true;
   #else
    return false;
   #endif
}

bool ProjectAudioProcessor::producesMidi() const
{
   #if JucePlugin_ProducesMidiOutput
    return true;
   #else
    return false;
   #endif
}

bool ProjectAudioProcessor::isMidiEffect() const
{
   #if JucePlugin_IsMidiEffect
    return true;
   #else
    return false;
   #endif
}

double ProjectAudioProcessor::getTailLengthSeconds() const
{
    return 0.0;
}



int ProjectAudioProcessor::getNumPrograms()
{
    return 1;   // NB: some hosts don't cope very well if you tell them there are 0 programs,
                // so this should be at least 1, even if you're not really implementing programs.
}

int ProjectAudioProcessor::getCurrentProgram()
{
    return 0;
}

void ProjectAudioProcessor::setCurrentProgram (int index)
{
}

const juce::String ProjectAudioProcessor::getProgramName (int index)
{
    return {};
}

void ProjectAudioProcessor::changeProgramName (int index, const juce::String& newName)
{
}

//==============================================================================
void ProjectAudioProcessor::prepareToPlay (double sampleRate, int samplesPerBlock)
{
    // Use this method as the place to do any pre-playback
    // initialisation that you need..

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    // SYMFesizer
    
    // DSP preparation with ProcessSpec component
    lastSampleRate = sampleRate;
    juce::dsp::ProcessSpec spec;

    // Specifications need sampleRate, maximumBlockSize, numChannels
    spec.sampleRate = sampleRate;
    spec.maximumBlockSize = samplesPerBlock;
    spec.numChannels = getTotalNumOutputChannels();

    // DSP methods of initialisation
    chorus.prepare(spec);
    chorus.reset();
    
    panner.prepare(spec);
    panner.reset();

    compressor.prepare(spec);
    compressor.reset();

    phaser.prepare(spec);
    phaser.reset();
    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
}

void ProjectAudioProcessor::releaseResources()
{
    // When playback stops, you can use this as an opportunity to free up any
    // spare memory, etc.
}

#ifndef JucePlugin_PreferredChannelConfigurations
bool ProjectAudioProcessor::isBusesLayoutSupported (const BusesLayout& layouts) const
{
  #if JucePlugin_IsMidiEffect
    juce::ignoreUnused (layouts);
    return true;
  #else
    // This is the place where you check if the layout is supported.
    // In this template code we only support mono or stereo.
    // Some plugin hosts, such as certain GarageBand versions, will only
    // load plugins that support stereo bus layouts.
    if (layouts.getMainOutputChannelSet() != juce::AudioChannelSet::mono()
     && layouts.getMainOutputChannelSet() != juce::AudioChannelSet::stereo())
        return false;

    // This checks if the input layout matches the output layout
   #if ! JucePlugin_IsSynth
    if (layouts.getMainOutputChannelSet() != layouts.getMainInputChannelSet())
        return false;
   #endif

    return true;
  #endif
}
#endif

void ProjectAudioProcessor::processBlock (juce::AudioBuffer<float>& buffer, juce::MidiBuffer& midiMessages)
{
    juce::ScopedNoDenormals noDenormals;
    auto totalNumInputChannels  = getTotalNumInputChannels();
    auto totalNumOutputChannels = getTotalNumOutputChannels();

    // In case we have more outputs than inputs, this code clears any output
    // channels that didn't contain input data, (because these aren't
    // guaranteed to be empty - they may contain garbage).
    // This is here to avoid people getting screaming feedback
    // when they first compile a plugin, but obviously you don't need to keep
    // this code if your algorithm always overwrites all the output channels.
    for (auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
        buffer.clear (i, 0, buffer.getNumSamples());

    // This is the place where you'd normally do the guts of your plugin's
    // audio processing...
    // Make sure to reset the state if your inner loop is processing
    // the samples and the outer loop is handling the channels.
    // Alternatively, you can process the samples with the channels
    // interleaved by keeping the same state.
    for (int channel = 0; channel < totalNumInputChannels; ++channel)
    {
        auto* channelData = buffer.getWritePointer (channel);

        // ..do something to the data...
    }

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    // SYMFesizer

    // Input AudioBlock buffer
    juce::dsp::AudioBlock <float> block(buffer);    // AudioBlock component for processing the input buffer

    // Reading the necessary parameters of the AudioProcessValueTreeState
    float chorusRate = *apvts.getRawParameterValue("ID_ChorusRate");
    float chorusDepth = *apvts.getRawParameterValue("ID_ChorusDepth");
    float chorusCentreDelay = *apvts.getRawParameterValue("ID_ChorusCentreDelay");
    float chorusFeedback = *apvts.getRawParameterValue("ID_ChorusFeedback");
    float chorusMix = *apvts.getRawParameterValue("ID_ChorusMix");
    
    
    float panValue = *apvts.getRawParameterValue("ID_PannerValue");
    
    
    float compressorThreshold = *apvts.getRawParameterValue("ID_CompressorThreshold");
    float compressorRatio = *apvts.getRawParameterValue("ID_CompressorRatio");
    float compressorAttack = *apvts.getRawParameterValue("ID_CompressorAttack");
    float compressorRelease = *apvts.getRawParameterValue("ID_CompressorRelease");
   
    
    float phaserRate = *apvts.getRawParameterValue("ID_PhaserRate");
    float phaserDepth = *apvts.getRawParameterValue("ID_PhaserDepth");
    float phaserCentreFrequency = *apvts.getRawParameterValue("ID_PhaserCentreFrequency");
    float phaserFeedback = *apvts.getRawParameterValue("ID_PhaserFeedback");
    float phaserMix = *apvts.getRawParameterValue("ID_PhaserMix");

    // Updating the chorus state
    chorus.setRate(chorusRate);
    chorus.setDepth(chorusDepth);
    chorus.setCentreDelay(chorusCentreDelay);
    chorus.setFeedback(chorusFeedback);
    chorus.setMix(chorusMix);

    // Updating the panner state
    panner.setRule(juce::dsp::PannerRule::balanced);
    panner.setPan(panValue);
    
    // Updating the compressor state
    compressor.setThreshold(compressorThreshold);
    compressor.setRatio(compressorRatio);
    compressor.setAttack(compressorAttack);
    compressor.setRelease(compressorRelease);
    
    
    // Updating the phaser state
    phaser.setRate(phaserRate);
    phaser.setDepth(phaserDepth);
    phaser.setCentreFrequency(phaserCentreFrequency);
    phaser.setFeedback(phaserFeedback);
    phaser.setMix(phaserMix);
    
    
    // Applying effects on input samples
    chorus.process(juce::dsp::ProcessContextReplacing<float>(block));
    panner.process(juce::dsp::ProcessContextReplacing<float>(block));
    compressor.process(juce::dsp::ProcessContextReplacing<float>(block));
    phaser.process(juce::dsp::ProcessContextReplacing<float>(block));


}

//==============================================================================
bool ProjectAudioProcessor::hasEditor() const
{
    return true; // (change this to false if you choose to not supply an editor)
}

juce::AudioProcessorEditor* ProjectAudioProcessor::createEditor()
{
    return new ProjectAudioProcessorEditor (*this);
}

//==============================================================================
void ProjectAudioProcessor::getStateInformation (juce::MemoryBlock& destData)
{
    // You should use this method to store your parameters in the memory block.
    // You could do that either as raw data, or use the XML or ValueTree classes
    // as intermediaries to make it easy to save and load complex data.
}

void ProjectAudioProcessor::setStateInformation (const void* data, int sizeInBytes)
{
    // You should use this method to restore your parameters from this memory block,
    // whose contents will have been created by the getStateInformation() call.
}

//==============================================================================
// This creates new instances of the plugin..
juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new ProjectAudioProcessor();
}

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// SYMFesizer
// 
// Definition and linking of parameters
juce::AudioProcessorValueTreeState::ParameterLayout ProjectAudioProcessor::createParameters()
{
    std::vector <std::unique_ptr <juce::RangedAudioParameter>> parameters;
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_ChorusRate", "Chorus Rate", 0.0, 4.0, 1.0));     // ID, name, min_value, max_value, default_value
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_ChorusDepth", "Chorus Depth", 0.0f, 1.0f, 0.5f));
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_ChorusCentreDelay", "Chorus Centre Delay", 1.0, 100.0, 50.0));
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_ChorusFeedback", "Chorus Feedback", -1.0f, 1.0f, 0.0f));
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_ChorusMix", "Chorus Mix", 0.0f, 1.0f, 0.5f));
    
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_PannerValue", "Pan", -1.0f, 1.0f, 0.0f));
    
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_CompressorThreshold", "Compressor Threshold", -50.0, 0.0, -25.0));
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_CompressorRatio", "Compressor Ratio", 1.0, 30.0, 6.0));
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_CompressorAttack", "Compressor Attack", 0.0, 200.0, 50.0));
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_CompressorRelease", "Compressor Release", 5.0, 5000.0, 160.0));
    
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_PhaserRate", "Phaser Rate", 0.0, 4.0, 1.0));     
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_PhaserDepth", "Phaser Depth", 0.0f, 1.0f, 0.5f));
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_PhaserCentreFrequency", "Phaser CentreFrequency", 1.0, 10000.0, 5000.0));
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_PhaserFeedback", "Phaser Feedback", -1.0f, 1.0f, 0.0f));
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_PhaserMix", "Phaser Mix", 0.0f, 1.0f, 0.5f));


    return {parameters.begin(), parameters.end()};
}





//Connection to Supercollider in order to interprete and log OSC message, in order to change the value of each knob
void ProjectAudioProcessor::oscMessageReceived(const juce::OSCMessage& message) {
    
    if (message.size() == 1 && message[0].isFloat32()) {
        
        if (message.getAddressPattern() == "/chorus/rate") {   //same knob in processing
            std::cout << "message obtained = " << message[0].getFloat32() << std::endl;

            //midi[0] = message[0].getInt32();
        }  
        if (message.getAddressPattern() == "/chorus/depth") {   
            std::cout << "message obtained = " << message[0].getFloat32() << std::endl;
            //midi[0] = message[0].getInt32();
        } 
         if (message.getAddressPattern() == "/chorus/centreDelay") {   
            std::cout << "message obtained = " << message[0].getFloat32() << std::endl;
            //midi[0] = message[0].getInt32();
        } 
         if (message.getAddressPattern() == "/chorus/feedback") {   
            std::cout << "message obtained = " << message[0].getFloat32() << std::endl;
            //midi[0] = message[0].getInt32();
        } 
         if (message.getAddressPattern() == "/chorus/mix") {   
            std::cout << "message obtained = " << message[0].getFloat32() << std::endl;
            //midi[0] = message[0].getInt32();
        } 
    
        if (message.getAddressPattern() == "/panner/value") {    
            std::cout << "message obtained = " << message[0].getFloat32() << std::endl;
            //midi[1] = message[0].getInt32();
        }
        
        if (message.getAddressPattern() == "/compressor/threshold") {    
            std::cout << "message obtained = " << message[0].getFloat32() << std::endl;
            //midi[2] = message[0].getInt32();
        }
        if (message.getAddressPattern() == "/compressor/ratio") {    
            std::cout << "message obtained = " << message[0].getFloat32() << std::endl;
            //midi[2] = message[0].getInt32();
        }
        if (message.getAddressPattern() == "/compressor/attack") {    
            std::cout << "message obtained = " << message[0].getFloat32() << std::endl;
            //midi[2] = message[0].getInt32();
        }
        if (message.getAddressPattern() == "/compressor/release") {   
            std::cout << "message obtained = " << message[0].getFloat32() << std::endl;
            //midi[2] = message[0].getInt32();
        }
        
        if (message.getAddressPattern() == "/phaser/rate") {   
            std::cout << "message obtained = " << message[0].getFloat32() << std::endl;
            //midi[0] = message[0].getInt32();
        }  
        if (message.getAddressPattern() == "/phaser/depth") {   
            std::cout << "message obtained = " << message[0].getFloat32() << std::endl;
            //midi[0] = message[0].getInt32();
        } 
         if (message.getAddressPattern() == "/phaser/centreFrequency") {   
            std::cout << "message obtained = " << message[0].getFloat32() << std::endl;
            //midi[0] = message[0].getInt32();
        } 
         if (message.getAddressPattern() == "/phaser/feedback") {   
            std::cout << "message obtained = " << message[0].getFloat32() << std::endl;
            //midi[0] = message[0].getInt32();
        } 
         if (message.getAddressPattern() == "/phaser/mix") {   
            std::cout << "message obtained = " << message[0].getFloat32() << std::endl;
            //midi[0] = message[0].getInt32();
        } 
        std::cout << "message obtained = " << message[0].getFloat32() << std::endl;
    }
}

